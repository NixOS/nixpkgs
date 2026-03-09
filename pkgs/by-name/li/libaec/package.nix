{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libaec";
  version = "1.1.6";

  src = fetchFromGitLab {
    domain = "gitlab.dkrz.de";
    owner = "k202009";
    repo = "libaec";
    rev = "v${version}";
    sha256 = "sha256-cxDP+JNwokxgzH9hO2zw+rIcz8XG7E8ujbAbWpgUEW8=";
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
