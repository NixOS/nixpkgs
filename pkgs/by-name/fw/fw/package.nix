{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "fw";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = "fw";
    rev = "v${version}";
    hash = "sha256-tqtiAw4+bnCJMF37SluAE9NM55MAjBGkJTvGLcmYFnA=";
  };

  cargoHash = "sha256-B32GegI3rvame0Ds+8+oBVUbcNhr2kwm3oVVxng8BZY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Workspace productivity booster";
    homepage = "https://github.com/brocode/fw";
    license = licenses.wtfpl;
    maintainers = [ ];
    mainProgram = "fw";
  };
}
