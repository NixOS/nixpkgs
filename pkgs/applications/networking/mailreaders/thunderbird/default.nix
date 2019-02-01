{ stdenv, fetchurl, fetchpatch, callPackage, makeDesktopItem, autoconf213
, cargo, m4, perl, pkgconfig, python2, rustc, unzip, which, wrapGAppsHook, yasm
, dbus, dbus-glib, gtk2, gtk3, hunspell, icu, jemalloc, libevent, libjpeg
, libnotify, libpng, libpulseaudio, libstartup_notification, pango, sqlite
, xorg, zip, zlib, gcc, llvmPackages, debugBuild ? false
, enableCalendar ? true, enableOfficialBranding ? true }:

with stdenv.lib;

let
  desktopItem = makeDesktopItem {
    categories = concatStringsSep ";" [
      "Application"
      "Network"
    ];
    desktopName = "Thunderbird";
    genericName = "Mail Reader";
    name = "thunderbird";
    exec = "thunderbird %U";
    icon = "$out/lib/thunderbird/chrome/icons/default/default256.png";
    mimeType = concatStringsSep ";" [
      # Email
      "x-scheme-handler/mailto"
      "message/rfc822"
      # Feeds
      "x-scheme-handler/feed"
      "application/rss+xml"
      "application/x-extension-rss"
      # Newsgroups
      "x-scheme-handler/news"
      "x-scheme-handler/snews"
      "x-scheme-handler/nntp"
    ];
  };
in

stdenv.mkDerivation rec {
  name = "thunderbird-${version}";
  version = "60.5.0";

  src = fetchurl {
    url = "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
    sha512 = "39biv0yk08l4kkfrsiqgsdsvpa7ih992jmakjnf2wqzrnbk4pfsrck6bnl038bihs1v25ia8c2vs25sm4wzbxzjr0z82fn31qysv2xi";
  };

  nativeBuildInputs = [
    autoconf213
    cargo
    m4
    perl
    pkgconfig
    python2
    rustc
    unzip
    which
    wrapGAppsHook
    yasm
  ];

  buildInputs = [
    dbus
    dbus-glib
    gtk2
    gtk3
    hunspell
    icu
    jemalloc
    libevent
    libjpeg
    libnotify
    libpng
    libpulseaudio
    libstartup_notification
    pango
    sqlite
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXext
    xorg.libXft
    xorg.libXi
    xorg.libXrender
    xorg.libXt
    xorg.pixman
    zip
    zlib
  ];

  patches = [
    # Remove buildconfig.html to prevent a dependency on clang:
    ./no-buildconfig.diff
  ];

  configureFlags = [
    "--enable-application=comm/mail"
    "--enable-default-toolkit=cairo-gtk3"
    "--enable-jemalloc"
    "--enable-js-shell"
    "--enable-rust-simd"
    "--enable-startup-notification"

    "--disable-alsa"
    "--disable-crashreporter"
    "--disable-gconf"
    "--disable-tests" # tests require network access
    "--disable-updater"

    "--enable-system-ffi"
    "--enable-system-hunspell"
    "--enable-system-pixman"
    "--enable-system-sqlite"
    "--with-system-bz2"
    "--with-system-icu"
    "--with-system-jpeg"
    "--with-system-libevent"
    "--with-system-png"
    "--with-system-zlib"

    "--with-clang-path=${llvmPackages.clang}/bin/clang"
    "--with-libclang-path=${llvmPackages.libclang}/lib"
  ] ++ optional enableCalendar "--enable-calendar"
    ++ optional enableOfficialBranding "--enable-official-branding"
    ++ (if debugBuild then [ "--enable-debug"
                             "--enable-profiling"]
                      else [ "--disable-debug"
                             "--enable-release"
                             "--disable-debug-symbols"
                             "--enable-optimize"
                             "--enable-strip" ]);

  enableParallelBuilding = true;

  preConfigure = ''
    export BINDGEN_SYSTEM_FLAGS="-cxx-isystem ${gcc}/lib/c++/${getVersion gcc} -isystem $(cc -dumpmachine)"
    configureScript=$PWD/configure

    mkdir ../target
    cd ../target
  '';

  postInstall = ''
    ${desktopItem.buildCommand}
  '';

  postFixup = ''
    # libXUL dlopens libinotify, see:
    # https://github.com/NixOS/nixpkgs/issues/18712
    local xul=$out/lib/thunderbird/libxul.so
    patchelf --set-rpath "${libnotify}/lib:$(patchelf --print-rpath $xul)" $xul
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/thunderbird --version
  '';

  disallowedRequisites = [ stdenv.cc ];

  meta = with stdenv.lib; {
    description = "A full-featured e-mail client";
    homepage = http://www.mozilla.org/thunderbird/;
    license = licenses.mpl20;
    maintainers = with maintainers; [
      eelco
      pierron
      yegortimoshenko
    ];
    platforms = platforms.linux;
  };

  passthru.updateScript = callPackage ../../browsers/firefox/update.nix {
    attrPath = "thunderbird";
    baseUrl = "http://archive.mozilla.org/pub/thunderbird/releases/";
  };
}
