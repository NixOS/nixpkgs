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
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "pezmaster31";
    repo = "bamtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3kIa407YgBpulh2koQQFK/RLmGEZvEvTnZyWKm+pngg=";
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
    changelog = "https://github.com/pezmaster31/bamtools/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
