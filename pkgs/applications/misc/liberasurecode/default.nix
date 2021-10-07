{ lib, stdenv, fetchFromGitHub, autoreconfHook, zlib }:

stdenv.mkDerivation rec {
  pname = "liberasurecode";
  version = "1.6.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "openstack";
    repo = pname;
    rev = version;
    sha256 = "sha256-qV7DL/7zrwrYOaPj6iHnChGA6KHFwYKjeaMnrGrTPrQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Erasure Code API library written in C with pluggable Erasure Code backends";
    homepage = "https://github.com/openstack/liberasurecode";
    license = licenses.bsd2;
    maintainers = teams.openstack.members;
  };
}
