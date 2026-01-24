{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libaec";
  version = "1.1.5";

  src = fetchFromGitLab {
    domain = "gitlab.dkrz.de";
    owner = "k202009";
    repo = "libaec";
    rev = "v${version}";
    sha256 = "sha256-ADydaLu8fV0mKp3wZx10VS2I1GFwuLTpbxmRKCmgF0c=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.dkrz.de/k202009/libaec";
    description = "Adaptive Entropy Coding library";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
