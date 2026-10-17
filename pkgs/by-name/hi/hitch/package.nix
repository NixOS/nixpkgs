{
  lib,
  stdenv,
  fetchurl,
  docutils,
  libev,
  openssl,
  pkg-config,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "1.8.0";
  pname = "hitch";

  src = fetchurl {
    url = "https://hitch-tls.org/source/hitch-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-38mUhLx//qJ6MWnoTWwheYjtpHsgirLlUk3Cpd0Vj04=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    docutils
    libev
    openssl
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  passthru.tests.hitch = nixosTests.hitch;

  meta = {
    description = "Libev-based high performance SSL/TLS proxy by Varnish Software";
    homepage = "https://hitch-tls.org/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.jflanglois ];
    platforms = lib.platforms.linux;
    mainProgram = "hitch";
  };
})
