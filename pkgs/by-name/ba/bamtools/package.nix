{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  jsoncpp,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bamtools";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "pezmaster31";
    repo = "bamtools";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-l2DmA4P1kPneTCL9YVACE6LcQHT0F+mufPyM69VkksE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    jsoncpp
    zlib
  ];

  doCheck = true;

  meta = with lib; {
    description = "C++ API & command-line toolkit for working with BAM data";
    mainProgram = "bamtools";
    homepage = "https://github.com/pezmaster31/bamtools";
    changelog = "https://github.com/pezmaster31/bamtools/releases/tag/${lib.removePrefix "refs/tags/" finalAttrs.src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
