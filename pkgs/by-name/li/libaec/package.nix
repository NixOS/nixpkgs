{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libaec";
  version = "1.1.6";

  src = fetchFromGitLab {
    domain = "gitlab.dkrz.de";
    owner = "k202009";
    repo = "libaec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cxDP+JNwokxgzH9hO2zw+rIcz8XG7E8ujbAbWpgUEW8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.dkrz.de/k202009/libaec";
    description = "Adaptive Entropy Coding library";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
