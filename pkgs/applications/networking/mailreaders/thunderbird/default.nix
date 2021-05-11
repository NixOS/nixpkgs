{ autoconf213
, bzip2
, cargo
, common-updater-scripts
, coreutils
, curl
, dbus
, dbus-glib
, fetchpatch
, fetchurl
, file
, fontconfig
, freetype
, glib
, gnugrep
, gnused
, gnupg
, gpgme
, icu
, jemalloc
, lib
, libGL
, libGLU
, libevent
, libjpeg
, libnotify
, libpng
, libstartup_notification
, libvpx
, libwebp
, llvmPackages
, m4
, makeDesktopItem
, nasm
, nodejs
, nspr
, nss_3_53
, pango
, perl
, pkgconfig
, python2
, python3
, runtimeShell
, rust-cbindgen
, rustc
, sqlite
, stdenv
, systemd
, unzip
, which
, writeScript
, xidel
, xorg
, yasm
, zip
, zlib

, debugBuild ? false

, alsaSupport ? stdenv.isLinux, alsaLib
, pulseaudioSupport ? stdenv.isLinux, libpulseaudio
, gtk3Support ? true, gtk2, gtk3, wrapGAppsHook
, waylandSupport ? true
, libxkbcommon, calendarSupport ? true

# Use official trademarked branding.  Permission obtained at:
# https://github.com/NixOS/nixpkgs/pull/94880#issuecomment-675907971
, enableOfficialBranding ? true
}:

assert waylandSupport -> gtk3Support == true;

stdenv.mkDerivation rec {
  pname = "thunderbird";
  version = "78.10.1";

  src = fetchurl {
    url =
      "mirror://mozilla/thunderbird/releases/${version}/source/thunderbird-${version}.source.tar.xz";
    sha512 =
      "3dy8db83sw7kvv0pqqzrnidpa0s6j4vl32f08pgka68pgaldxbr9ay4m1amvjafykz4mpk161v35g4dzb1xf7sxdfl38621yayf9ypz";
  };

  nativeBuildInputs = [
    autoconf213
    cargo
    gnused
    llvmPackages.llvm
    m4
    nasm
    nodejs
    perl
    pkgconfig
    python2
    python3
    rust-cbindgen
    rustc
    which
    yasm
  ] ++ lib.optional gtk3Support wrapGAppsHook;

  buildInputs = [
    bzip2
    dbus
    dbus-glib
    file
    fontconfig
    freetype
    glib
    gtk2
    icu
    jemalloc
    libGL
    libGLU
    libevent
    libjpeg
    libnotify
    libpng
    libstartup_notification
    libvpx
    libwebp
    nspr
    nss_3_53
    pango
    perl
    sqlite
    unzip
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcursor
    xorg.libXext
    xorg.libXft
    xorg.libXi
    xorg.libXrender
    xorg.libXt
    xorg.pixman
    xorg.xorgproto
    zip
    zlib
  ] ++ lib.optional alsaSupport alsaLib
    ++ lib.optional gtk3Support gtk3
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional waylandSupport libxkbcommon;

  NIX_CFLAGS_COMPILE =[
    "-I${glib.dev}/include/gio-unix-2.0"
    "-I${nss_3_53.dev}/include/nss"
  ];

  patches = [
    ./no-buildconfig.patch
  ];

  postPatch = ''
    rm -rf obj-x86_64-pc-linux-gnu
  '';

  hardeningDisable = [ "format" ];

  preConfigure = ''
    # remove distributed configuration files
    rm -f configure
    rm -f js/src/configure
    rm -f .mozconfig*

    configureScript="$(realpath ./mach) configure"
    # AS=as in the environment causes build failure https://bugzilla.mozilla.org/show_bug.cgi?id=1497286
    unset AS

    export MOZCONFIG=$(pwd)/mozconfig

    # Set C flags for Rust's bindgen program. Unlike ordinary C
    # compilation, bindgen does not invoke $CC directly. Instead it
    # uses LLVM's libclang. To make sure all necessary flags are
    # included we need to look in a few places.
    # TODO: generalize this process for other use-cases.

    BINDGEN_CFLAGS="$(< ${stdenv.cc}/nix-support/libc-crt1-cflags) \
      $(< ${stdenv.cc}/nix-support/libc-cflags) \
      $(< ${stdenv.cc}/nix-support/cc-cflags) \
      $(< ${stdenv.cc}/nix-support/libcxx-cxxflags) \
      ${
        lib.optionalString stdenv.cc.isClang
        "-idirafter ${stdenv.cc.cc}/lib/clang/${
          lib.getVersion stdenv.cc.cc
        }/include"
      } \
      ${
        lib.optionalString stdenv.cc.isGNU
        "-isystem ${stdenv.cc.cc}/include/c++/${
          lib.getVersion stdenv.cc.cc
        } -isystem ${stdenv.cc.cc}/include/c++/${
          lib.getVersion stdenv.cc.cc
        }/${stdenv.hostPlatform.config}"
      } \
      $NIX_CFLAGS_COMPILE"

    echo "ac_add_options BINDGEN_CFLAGS='$BINDGEN_CFLAGS'" >> $MOZCONFIG
  '';

  configureFlags = let
    toolkitSlug = if gtk3Support then
      "3${lib.optionalString waylandSupport "-wayland"}"
    else
      "2";
    toolkitValue = "cairo-gtk${toolkitSlug}";
  in [
    "--enable-application=comm/mail"

    "--with-system-icu"
    "--with-system-jpeg"
    "--with-system-libevent"
    "--with-system-nspr"
    "--with-system-nss"
    "--with-system-png" # needs APNG support
    "--with-system-zlib"
    "--with-system-webp"
    "--with-system-libvpx"

    "--enable-rust-simd"
    "--enable-crashreporter"
    "--enable-default-toolkit=${toolkitValue}"
    "--enable-js-shell"
    "--enable-necko-wifi"
    "--enable-system-ffi"
    "--enable-system-pixman"

    "--disable-tests"
    "--disable-updater"
    "--enable-jemalloc"
  ] ++ (if debugBuild then [
    "--enable-debug"
    "--enable-profiling"
  ] else [
    "--disable-debug"
    "--enable-release"
    "--disable-debug-symbols"
    "--enable-optimize"
    "--enable-strip"
  ]) ++ lib.optionals (!stdenv.hostPlatform.isi686) [
    # on i686-linux: --with-libclang-path is not available in this configuration
    "--with-libclang-path=${llvmPackages.libclang}/lib"
    "--with-clang-path=${llvmPackages.clang}/bin/clang"
  ] ++ lib.optional alsaSupport "--enable-alsa"
  ++ lib.optional calendarSupport "--enable-calendar"
  ++ lib.optional enableOfficialBranding "--enable-official-branding"
  ++ lib.optional pulseaudioSupport "--enable-pulseaudio";

  enableParallelBuilding = true;

  postConfigure = ''
    cd obj-*
  '';

  makeFlags = lib.optionals enableOfficialBranding [
    "MOZILLA_OFFICIAL=1"
    "BUILD_OFFICIAL=1"
  ];

  doCheck = false;

  postInstall = let
    desktopItem = makeDesktopItem {
      categories = lib.concatStringsSep ";" [ "Application" "Network" ];
      desktopName = "Thunderbird";
      genericName = "Mail Reader";
      name = "thunderbird";
      exec = "thunderbird %U";
      icon = "$out/lib/thunderbird/chrome/icons/default/default256.png";
      mimeType = lib.concatStringsSep ";" [
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
  in ''
    # TODO: Move to a dev output?
    rm -rf $out/include $out/lib/thunderbird-devel-* $out/share/idl

    ${desktopItem.buildCommand}
  '';

  # Note on GPG support:
  # Thunderbird's native GPG support does not yet support smartcards.
  # The official upstream recommendation is to configure fall back to gnupg
  # using the Thunderbird config `mail.openpgp.allow_external_gnupg`
  # and GPG keys set up; instructions with pictures at:
  # https://anweshadas.in/how-to-use-yubikey-or-any-gpg-smartcard-in-thunderbird-78/
  # For that to work out of the box, it requires `gnupg` on PATH and
  # `gpgme` in `LD_LIBRARY_PATH`; we do this below.

  preFixup = ''
    # Needed to find Mozilla runtime
    gappsWrapperArgs+=(
      --argv0 "$out/bin/thunderbird"
      --set MOZ_APP_LAUNCHER thunderbird
      # https://github.com/NixOS/nixpkgs/pull/61980
      --set SNAP_NAME "thunderbird"
      --set MOZ_LEGACY_PROFILES 1
      --set MOZ_ALLOW_DOWNGRADE 1
      --prefix PATH : "${lib.getBin gnupg}/bin"
      --prefix LD_LIBRARY_PATH : "${lib.getLib gpgme}/lib"
    )
  '';

  # FIXME: The XUL portion of this can probably be removed as soon as we
  # package a Thunderbird >=71.0 since XUL shouldn't be anymore (in use)?
  postFixup = ''
    local xul="$out/lib/thunderbird/libxul.so"
    patchelf --set-rpath "${libnotify}/lib:${lib.getLib systemd}/lib:$(patchelf --print-rpath $xul)" $xul
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    "$out/bin/thunderbird" --version
  '';

  disallowedRequisites = [
    stdenv.cc
  ];

  passthru.updateScript = import ./../../browsers/firefox/update.nix {
    attrPath = "thunderbird-78";
    baseUrl = "http://archive.mozilla.org/pub/thunderbird/releases/";
    inherit writeScript lib common-updater-scripts xidel coreutils gnused
      gnugrep curl runtimeShell;
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with stdenv.lib; {
    description = "A full-featured e-mail client";
    homepage = "https://www.thunderbird.net";
    maintainers = with maintainers; [
      eelco
      lovesegfault
      pierron
      vcunat
    ];
    platforms = platforms.linux;
    license = licenses.mpl20;
  };
}
