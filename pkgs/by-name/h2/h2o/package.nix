{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  makeBinaryWrapper,
  ninja,
  perl,
  perlPackages,
  openssl,
  libcap,
  libuv,
  wslay,
  zlib,
  withBrotli ? true,
  brotli,
  withMruby ? true,
  bison,
  ruby,
  withUring ? stdenv.hostPlatform.isLinux,
  liburing,
  withZstandard ? true,
  zstd,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "h2o";
  version = "2.3.0-rolling-2026-07-31";

  src = fetchFromGitHub {
    owner = "h2o";
    repo = "h2o";
    rev = "ba16320ad18c2bb2e28478ce9e37b9a57a5c98f6";
    hash = "sha256-MmfypvlLJ3NeZ1Nyeyzo1mXxICllQPBwwseOo+rC1Ig=";
  };

  outputs = [
    "out"
    "man"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    makeBinaryWrapper
    ninja
    perlPackages.JSON
  ]
  ++ lib.optional withBrotli brotli
  ++ lib.optionals withMruby [
    bison
    ruby
  ]
  ++ lib.optional withUring liburing
  ++ lib.optional withZstandard zstd;

  buildInputs = [
    brotli
    openssl
    libcap
    libuv
    perl
    zlib
    wslay
  ]
  ++ lib.optional withBrotli brotli
  ++ lib.optional withZstandard zstd;

  cmakeFlags = [
    (lib.cmakeBool "WITH_BROTLI" withBrotli)
    (lib.cmakeBool "WITH_MRUBY" withMruby)
    (lib.cmakeBool "WITH_ZSTD" withZstandard)
  ];

  postInstall = ''
    EXES="$(find "$out/share/h2o" -type f -executable)"
    for exe in $EXES; do
      wrapProgram "$exe" \
        --set "H2O_PERL" "${lib.getExe perl}" \
        --prefix "PATH" : "${lib.getBin openssl}/bin"
    done

    wrapProgram "$out/bin/h2olog" \
        --set "PERL5LIB" "$PERL5LIB"
  '';

  passthru = {
    tests = { inherit (nixosTests) h2o; };
  };

  meta = {
    description = "Optimized HTTP/1.x, HTTP/2, HTTP/3 server";
    homepage = "https://h2o.examp1e.net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      toastal
      thoughtpolice
    ];
    mainProgram = "h2o";
    platforms = lib.platforms.linux;
  };
})
