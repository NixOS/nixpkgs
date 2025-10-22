{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "kcp";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "kcp";
    rev = version;
    hash = "sha256-yW40x4T++4rB7hoabGN8qiSN7octyoUYEfE9oDlLxjU=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Fast and Reliable ARQ Protocol";
    homepage = "https://github.com/skywind3000/kcp";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
