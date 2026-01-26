{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libaec";
  version = "1.1.4";

  src = fetchFromGitLab {
    domain = "gitlab.dkrz.de";
    owner = "k202009";
    repo = "libaec";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-MJFx0gErfrSK6EeeGDk8CQWj6j4PVvFPJEI/iys3bI8=";
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
})
