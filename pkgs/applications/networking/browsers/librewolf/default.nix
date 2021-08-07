{ stdenv
, lib
, fetchFromGitHub
, writeScript
, alsa-lib
, autoconf213
, cairo
, desktop-file-utils
, dbus
, dbus-glib
, ffmpeg
, fontconfig
, freetype
, gnome2
, gnum4
, gtk2
, libevent
, libGL
, libGLU
, libnotify
, libpulseaudio
, libstartup_notification
, perl
, pkg-config
, python2
, unzip
, which
, wrapGAppsHook
, xorg
, yasm
, zip
, zlib
, withGTK3 ? true
, gtk3
}:

# Only specific GCC versions are supported with branding
# https://developer.palemoon.org/build/linux/
assert stdenv.cc.isGNU;
assert with lib.strings; (
  versionAtLeast stdenv.cc.version "4.9"
  && !hasPrefix "6" stdenv.cc.version
  && versionOlder stdenv.cc.version "11"
);

let
  libPath = lib.makeLibraryPath [
    ffmpeg
    libpulseaudio
  ];
  gtkVersion = if withGTK3 then "3" else "2";
in
stdenv.mkDerivation rec {
  pname = "librewolf";
  version = "90.0.2";

    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
      sha512 = "4fda0b1e666fb0b1d846708fad2b48a5b53d48e7fc2a5da1f234b5b839c55265b41f6509e6b506d5e8a7455f816dfa5ab538589bc9e83b7e3846f0f72210513e";
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
    libevent
    libGL
    libGLU
    libnotify
    libpulseaudio
    libstartup_notification
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
  ++ lib.optional withGTK3 gtk3;

  enableParallelBuilding = true;

  configurePhase = ''
    runHook preConfigure

    export MOZCONFIG=$PWD/mozconfig
    export MOZ_NOSPAM=1

    # Keep this similar to the official .mozconfig file,
    # only minor changes for portability are permitted with branding.
    # https://developer.palemoon.org/build/linux/
    echo > $MOZCONFIG '
    # Clear this if not a 64bit build
    _BUILD_64=${lib.optionalString stdenv.hostPlatform.is64bit "1"}

    # Set GTK Version to 2 or 3
    _GTK_VERSION=${gtkVersion}

    # Standard build options for Pale Moon
    ac_add_options --enable-application=palemoon
    ac_add_options --enable-optimize="-O2 -w"
    ac_add_options --enable-default-toolkit=cairo-gtk$_GTK_VERSION
    ac_add_options --enable-jemalloc
    ac_add_options --enable-strip
    ac_add_options --enable-devtools
    ac_add_options --enable-av1

    ac_add_options --disable-eme
    ac_add_options --disable-webrtc
    ac_add_options --disable-gamepad
    ac_add_options --disable-tests
    ac_add_options --disable-debug
    ac_add_options --disable-necko-wifi
    ac_add_options --disable-updater

    ac_add_options --with-pthreads

    # Please see https://www.palemoon.org/redist.shtml for restrictions when using the official branding.
    ac_add_options --enable-official-branding
    export MOZILLA_OFFICIAL=1

    ac_add_options --x-libraries=${lib.makeLibraryPath [ xorg.libX11 ]}

    #
    # NixOS-specific adjustments
    #

    ac_add_options --prefix=$out

    mk_add_options MOZ_MAKE_FLAGS="-j${if enableParallelBuilding then "$NIX_BUILD_CORES" else "1"}"
    mk_add_options AUTOCONF=${autoconf213}/bin/autoconf
    '

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

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${libPath}"
    )
    wrapGApp $out/lib/palemoon-${version}/palemoon
  '';

  meta = with lib; {
    description = "Community-maintained fork of Firefox, focused on privacy, security and freedom";
    homepage = "https://librewolf-community.gitlab.io/";
    changelog = "https://gitlab.com/librewolf-community/browser/linux/-/blob/v${version}-1/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ onny ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
