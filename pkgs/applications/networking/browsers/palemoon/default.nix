{ lib
, stdenv
, alsa-lib
, autoconf213
, cairo
, dbus
, dbus-glib
, desktop-file-utils
, fetchzip
, ffmpeg
, fontconfig
, freetype
, gnome2
, gnum4
, libGL
, libGLU
, libevent
, libnotify
, libpulseaudio
, libstartup_notification
, pango
, perl
, pkg-config
, python2
, unzip
, which
, wrapGAppsHook
, writeScript
, xorg
, yasm
, zip
, zlib
, withGTK3 ? true, gtk3, gtk2
}:

# Only specific GCC versions are supported with branding
# https://developer.palemoon.org/build/linux/
assert stdenv.cc.isGNU;
assert with lib.strings; (
  versionAtLeast stdenv.cc.version "4.9"
  && !hasPrefix "6" stdenv.cc.version
  && versionOlder stdenv.cc.version "11"
);

stdenv.mkDerivation rec {
  pname = "palemoon";
  version = "29.4.4";

  src = fetchzip {
    name = "${pname}-${version}";
    url = "http://archive.palemoon.org/source/${pname}-${version}.source.tar.xz";
    sha256 = "sha256-0R0IJd4rd7NqnxQxkHSx10cNlwECqpKgJnlfYAMx4wc=";
  };

  nativeBuildInputs = [
    autoconf213
    desktop-file-utils
    gnum4
    perl
    pkg-config
    python2
    unzip
    which
    wrapGAppsHook
    yasm
    zip
  ];

  buildInputs = [
    alsa-lib
    cairo
    dbus
    dbus-glib
    ffmpeg
    fontconfig
    freetype
    gnome2.GConf
    gtk2
    libGL
    libGLU
    libevent
    libnotify
    libpulseaudio
    libstartup_notification
    pango
    zlib
  ]
  ++ (with xorg; [
    libX11
    libXext
    libXft
    libXi
    libXrender
    libXScrnSaver
    libXt
    pixman
    xorgproto
  ])
  ++ lib.optionals withGTK3 [
    gtk3
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs ./mach
  '';

  configurePhase = ''
    runHook preConfigure

    export MOZCONFIG=$PWD/mozconfig
    export MOZ_NOSPAM=1

    export build64=${lib.optionalString stdenv.hostPlatform.is64bit "1"}
    export gtkversion=${if withGTK3 then "3" else "2"}
    export xlibs=${lib.makeLibraryPath [ xorg.libX11 ]}
    export prefix=$out
    export mozmakeflags="-j${if enableParallelBuilding then "$NIX_BUILD_CORES" else "1"}"
    export autoconf=${autoconf213}/bin/autoconf

    substituteAll ${./mozconfig} $MOZCONFIG

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ./mach build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./mach install

    # Fix missing icon due to wrong WMClass
    # https://forum.palemoon.org/viewtopic.php?f=3&t=26746&p=214221#p214221
    substituteInPlace ./palemoon/branding/official/palemoon.desktop \
      --replace 'StartupWMClass="pale moon"' 'StartupWMClass=Pale moon'
    desktop-file-install --dir=$out/share/applications \
      ./palemoon/branding/official/palemoon.desktop

    # Install official branding icons
    for iconname in default{16,22,24,32,48,256} mozicon128; do
      n=''${iconname//[^0-9]/}
      size=$n"x"$n
      install -Dm644 ./palemoon/branding/official/$iconname.png $out/share/icons/hicolor/$size/apps/palemoon.png
    done

    # Remove unneeded SDK data from installation
    # https://forum.palemoon.org/viewtopic.php?f=37&t=26796&p=214676#p214729
    rm -rf $out/{include,share/idl,lib/palemoon-devel-${version}}

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup =
    let
      libPath = lib.makeLibraryPath [
        ffmpeg
        libpulseaudio
      ];
    in
      ''
        gappsWrapperArgs+=(
          --prefix LD_LIBRARY_PATH : "${libPath}"
        )
    wrapGApp $out/lib/palemoon-${version}/palemoon
  '';

  meta = with lib; {
    homepage = "https://www.palemoon.org/";
    description = "An Open Source, Goanna-based web browser focusing on efficiency and customization";
    longDescription = ''
      Pale Moon is an Open Source, Goanna-based web browser focusing on
      efficiency and customization.

      Pale Moon offers you a browsing experience in a browser completely built
      from its own, independently developed source that has been forked off from
      Firefox/Mozilla code a number of years ago, with carefully selected
      features and optimizations to improve the browser's stability and user
      experience, while offering full customization and a growing collection of
      extensions and themes to make the browser truly your own.
    '';
    changelog = "https://repo.palemoon.org/MoonchildProductions/Pale-Moon/releases/tag/${version}_Release";
    license = licenses.mpl20;
    maintainers = with maintainers; [ AndersonTorres OPNA2608 ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

  passthru.updateScript = writeScript "update-${pname}" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl libxml2

    set -eu -o pipefail

    # Only release note announcement == finalized release
    version="$(
      curl -s 'http://www.palemoon.org/releasenotes.shtml' |
      xmllint --html --xpath 'html/body/table/tbody/tr/td/h3/text()' - 2>/dev/null | head -n1 |
      sed 's/v\(\S*\).*/\1/'
    )"
    update-source-version ${pname} "$version"
  '';
}
