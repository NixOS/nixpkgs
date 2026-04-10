{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  makeWrapper,
  ninja,
  perl,
  perlPackages,
  brotli,
  openssl,
  libcap,
  libuv,
  wslay,
  zlib,
  withMruby ? true,
  bison,
  ruby,
  withUring ? stdenv.hostPlatform.isLinux,
  liburing,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "h2o";
  version = "2.3.0-rolling-2026-04-15";

  src = fetchFromGitHub {
    owner = "h2o";
    repo = "h2o";
    rev = "4aa96860e99cc2a2e2777433949bb05aed678ebe";
    hash = "sha256-0utcajHyLpP+MXwW12pGWd/E58jK5//Erq0dQmzBO5U=";
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
    makeWrapper
    ninja
    perlPackages.JSON
  ]
  ++ lib.optionals withMruby [
    bison
    ruby
  ]
  ++ lib.optional withUring liburing;

  buildInputs = [
    brotli
    openssl
    libcap
    libuv
    perl
    zlib
    wslay
  ];

  cmakeFlags = [
    "-DWITH_MRUBY=${if withMruby then "ON" else "OFF"}"
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
