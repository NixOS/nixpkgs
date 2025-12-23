{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "argp-standalone";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "argp-standalone";
    repo = "argp-standalone";
    tag = version;
    sha256 = "jWnoWVnUVDQlsC9ru7oB9PdtZuyCCNqGnMqF/f2m0ZY=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/argp-standalone/argp-standalone";
    description = "Standalone version of arguments parsing functions from Glibc";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ amar1729 ];
    license = lib.licenses.lgpl21Plus;
  };
}
