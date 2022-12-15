{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl, protobufc, libconfig }:

stdenv.mkDerivation rec {
  pname = "umurmur";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "umurmur";
    repo = "umurmur";
    rev = version;
    sha256 = "sha256-jp5+NbGmT90ksffvpLYIX2q5cPeVidDCYMPvLHCiP68=";
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
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
