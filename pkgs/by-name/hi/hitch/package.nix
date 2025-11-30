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
stdenv.mkDerivation rec {
  version = "1.8.0";
  pname = "hitch";

  src = fetchurl {
    url = "https://hitch-tls.org/source/${pname}-${version}.tar.gz";
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

  meta = with lib; {
    description = "Libev-based high performance SSL/TLS proxy by Varnish Software";
    homepage = "https://hitch-tls.org/";
    license = licenses.bsd2;
    maintainers = [ maintainers.jflanglois ];
    platforms = platforms.linux;
    mainProgram = "hitch";
  };
}
