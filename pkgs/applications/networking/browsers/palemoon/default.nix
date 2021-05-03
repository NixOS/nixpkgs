# Compiler in stdenv MUST be a supported one for official branding
# See https://developer.palemoon.org/build/linux/
# TODO assert if stdenv.cc is supported?
{ stdenv
, lib
, fetchFromGitHub
, writeScript
, alsaLib
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

let
  libPath = lib.makeLibraryPath [
    ffmpeg
    libpulseaudio
  ];
  gtkVersion = if withGTK3 then "3" else "2";
in
stdenv.mkDerivation rec {
  pname = "palemoon";
  version = "29.2.0";

  src = fetchFromGitHub {
    githubBase = "repo.palemoon.org";
    owner = "MoonchildProductions";
    repo = "Pale-Moon";
    rev = "${version}_Release";
    sha256 = "0pa9j41bbfarwi60a6hxi5vpn52mwgr4p05l98acv4fcs1ccb427";
    fetchSubmodules = true;
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
    alsaLib
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

    export MOZ_PKG_SPECIAL=gtk$_GTK_VERSION

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
    # TODO report upstream
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
    # TODO: move to a separate output?
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
    homepage = "https://www.palemoon.org/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ AndersonTorres OPNA2608 ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
