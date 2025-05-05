{
  lib,
  stdenv,
  fetchFromGitLab,
  # build support
  autoreconfHook,
  flex,
  gnulib,
  pkg-config,
  texinfo,
  # libraries
  brotli,
  bzip2,
  gpgme,
  libhsts,
  libidn2,
  libpsl,
  lzip,
  nghttp2,
  openssl,
  pcre2,
  sslSupport ? true,
  xz,
  zlib,
  zstd,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "wget2";
  version = "2.2.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitLab {
    owner = "gnuwget";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-0tOoStZHr5opehFmuQdFRPYvOv8IMrDTBNFtoweY3VM=";
  };

  # wget2_noinstall contains forbidden reference to /build/
  postPatch = ''
    substituteInPlace src/Makefile.am \
      --replace-fail "bin_PROGRAMS = wget2 wget2_noinstall" "bin_PROGRAMS = wget2"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    flex
    lzip
    pkg-config
    texinfo
  ];

  buildInputs =
    [
      brotli
      bzip2
      gpgme
      libhsts
      libidn2
      libpsl
      nghttp2
      pcre2
      xz
      zlib
      zstd
    ]
    ++ lib.optionals sslSupport [
      openssl
    ];

  # TODO: include translation files
  autoreconfPhase = ''
    # copy gnulib into build dir and make writable.
    # Otherwise ./bootstrap copies the non-writable files from nix store and fails to modify them
    rmdir gnulib
    cp -r ${gnulib} gnulib
    chmod -R u+w gnulib/{build-aux,lib}

    ./bootstrap --no-git --gnulib-srcdir=gnulib --skip-po
  '';

  configureFlags = [
    (lib.enableFeature false "shared")
    # TODO: https://gitlab.com/gnuwget/wget2/-/issues/537
    (lib.withFeatureAs sslSupport "ssl" "openssl")
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";

  meta = with lib; {
    description = "Successor of GNU Wget, a file and recursive website downloader";
    longDescription = ''
      Designed and written from scratch it wraps around libwget, that provides the basic
      functions needed by a web client.
      Wget2 works multi-threaded and uses many features to allow fast operation.
      In many cases Wget2 downloads much faster than Wget1.x due to HTTP2, HTTP compression,
      parallel connections and use of If-Modified-Since HTTP header.
    '';
    homepage = "https://gitlab.com/gnuwget/wget2";
    # wget2 GPLv3+; libwget LGPLv3+
    license = with licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "wget2";
  };
}
