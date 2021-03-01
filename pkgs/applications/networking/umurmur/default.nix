{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl, protobufc, libconfig }:

stdenv.mkDerivation rec {
  pname = "umurmur";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "umurmur";
    repo = "umurmur";
    rev = version;
    sha256 = "sha256-86wveYlM493RIuU8aKac6XTOMPv0JxlZL4qH2N2AqRU=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl protobufc libconfig ];

  configureFlags = [
    "--with-ssl=openssl"
    "--enable-shmapi"
  ];

  meta = with lib; {
    description = "Minimalistic Murmur (Mumble server)";
    license = licenses.bsd3;
    homepage = "https://github.com/umurmur/umurmur";
    platforms = platforms.all;
  };
}
