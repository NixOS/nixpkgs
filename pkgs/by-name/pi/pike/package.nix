{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  autoconf,
  automake,
  libtool,
  bison,
  flex,
  gmp,
  pcre,
  nettle,
  libjpeg,
  libpng,
  libtiff,
  freetype,
  sqlite,
  libmysqlclient,
  postgresql,
  openssl,
  zlib,
  bzip2,
  gdbm,
  libffi,
  expat,
  libxml2,
  libxslt,
  gtk3,
  pango,
  cairo,
  glib,
  SDL2,
  libGL,
  dpkg,
  autoPatchelfHook,
  ncurses,
  libnsl,
  libxcrypt-legacy,
  nix-update-script,
  makeBinaryWrapper,
}:

let
  # Pre-built Pike binary from Debian for bootstrapping
  pike-bootstrap = stdenv.mkDerivation (finalAttrs: {
    pname = "pike-bootstrap";
    version = "8.0.1956";

    src = fetchurl {
      # Using Debian's pike8.0-core package
      url = "http://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0-core_${finalAttrs.version}-1_amd64.deb";
      hash = "sha256-kDaP7GZOW9Wlzg9dSxi+Q8IYduIZneWSsFqRfNh1NFQ=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeBinaryWrapper
    ];

    buildInputs = [
      gmp
      zlib
      ncurses
      libxcrypt-legacy # for libcrypt.so.1
      nettle # for libnettle and libhogweed
      libnsl # for libnsl.so
    ];

    # Ignore missing dependencies since this is just for bootstrapping
    autoPatchelfIgnoreMissingDeps = [
      "libcrypt.so.1"
      "libnsl.so.2"
    ];

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r usr/* $out/

      # The binary should be in bin/pike8.0
      if [ -f $out/bin/pike8.0 ]; then
        ln -s pike8.0 $out/bin/pike
      fi

      # Fix broken symlinks to Debian license files
      rm -f $out/lib/pike8.0/modules/Tools.pmod/Legal.pmod/License.pmod/*.txt || true

      # Create wrapper to set proper paths
      wrapProgram $out/bin/pike8.0 \
        --set PIKE_MODULE_PATH "$out/lib/pike8.0/modules" \
        --add-flags "-m$out/lib/pike8.0/master.pike"
      runHook postInstall
    '';
    meta = {
      description = "Pike programming language bootstrap";
      longDescription = ''
        Pike is a dynamic programming language with a syntax similar to Java and C.
        It is simple to learn, does not require long compilation passes and has
        powerful built-in data types allowing simple and really fast data manipulation.
      '';
      homepage = "https://pike.lysator.liu.se/";
      license = with lib.licenses; [
        gpl2Only
        # or
        lgpl2Plus
        # or
        mpl20
      ];
      maintainers = with lib.maintainers; [ siraben ];
      platforms = with lib.platforms; unix ++ windows;
      mainProgram = "pike";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pike";
  version = "8.0.2038";

  src = fetchFromGitHub {
    owner = "pikelang";
    repo = "Pike";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aaU9kSmdN/zMFTnqkp8renuMxTj1WwAQIudPy6ahm1M=";
  };

  nativeBuildInputs = [
    pkg-config
    bison
    flex
    autoconf
    automake
    libtool
    pike-bootstrap # built above
  ];

  buildInputs = [
    gmp
    pcre
    nettle
    libjpeg
    libpng
    libtiff
    freetype
    sqlite
    libmysqlclient
    postgresql
    openssl
    zlib
    bzip2
    gdbm
    libffi
    expat
    libxml2
    libxslt
    gtk3
    pango
    cairo
    glib
    SDL2
    libGL
  ];

  # Pike uses a custom build system
  preConfigure = ''
    patchShebangs .
    cd src
    ./run_autoconfig
  '';

  env = {
    RUNPIKE = "${pike-bootstrap}/bin/pike";
    PIKE = "${pike-bootstrap}/bin/pike";
  };

  configureFlags = [
    "--with-gmp"
    "--with-nettle"
    "--with-mysql=${libmysqlclient}"
    "--with-postgres"
    "--with-gtk"
    "--with-sdl"
    "--with-gl"
  ];

  makeFlags = [ "INSTALLARGS=--traditional" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pike programming language";
    longDescription = ''
      Pike is a dynamic programming language with a syntax similar to Java and C.
      It is simple to learn, does not require long compilation passes and has
      powerful built-in data types allowing simple and really fast data manipulation.
    '';
    homepage = "https://pike.lysator.liu.se/";
    license = with lib.licenses; [
      gpl2Only
      # or
      lgpl2Plus
      # or
      mpl20
    ];
    maintainers = with lib.maintainers; [ siraben ];
    platforms = with lib.platforms; unix ++ windows;
    mainProgram = "pike";
  };
})
