{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
  makeWrapper,
  ninja,
  perl,
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
  version = "2.3.0.20250717";

  src = fetchFromGitHub {
    owner = "h2o";
    repo = "h2o";
    rev = "db98b59ba7abfcd1dc9b43ea4b9ad1052aba775e";
    sha256 = "sha256-vBA5TWyvtaaBZV4RmfAAA7F34fXNkROS0rbZRpEJgrc=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/h2o/h2o/security/advisories/GHSA-mrjm-qq9m-9mjq
      # https://kb.cert.org/vuls/id/767506
      name = "CVE-2025-8671.patch";
      url = "https://github.com/h2o/h2o/commit/579ecfaca155d1f9f12bfd0cff6086dcda4b9692.patch";
      hash = "sha256-bNnhx5RGBw6SmKmhlACHKPsnVUPzQUqHsunPdiayzv0=";
    })
  ];

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
  '';

  passthru = {
    tests = { inherit (nixosTests) h2o; };
  };

  meta = with lib; {
    description = "Optimized HTTP/1.x, HTTP/2, HTTP/3 server";
    homepage = "https://h2o.examp1e.net";
    license = licenses.mit;
    maintainers = with maintainers; [
      toastal
      thoughtpolice
    ];
    mainProgram = "h2o";
    platforms = platforms.linux;
  };
})
