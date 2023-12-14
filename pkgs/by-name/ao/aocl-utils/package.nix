{ lib, stdenv, fetchFromGitHub, cmake } :

stdenv.mkDerivation rec {
  pname = "aocl-utils";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "aocl-utils";
    rev = version;
    hash = "sha256-7Vc3kE+YfqIt6VfvSamsVQRemolzs1sNJUVUZFKk/O8=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Interface to all AMD AOCL libraries to access CPU features";
    homepage = "https://github.com/amd/aocl-utils";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.markuskowa ];
  };
}
