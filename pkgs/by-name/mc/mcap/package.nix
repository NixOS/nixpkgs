{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  zstd,
  lz4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcap";
  version = "0.0.53";

  src = fetchFromGitHub {
    owner = "foxglove";
    repo = "mcap";
    rev = "releases/mcap-cli/v${finalAttrs.version}";
    hash = "sha256-1NJ50dgbizOSl0ZMoqmuQxHc7Ca5JgS1bJ7tREDaKIU=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/cpp";

  # Skip the configure phase
  dontConfigure = true;

  # Skip the build phase entirely
  dontBuild = true;

  buildInputs = [
    zlib
    zstd
    lz4
  ];

  installPhase = ''
    mkdir -p $out/include/mcap
    cp -r mcap/include/mcap/* $out/include/mcap
  '';

  meta = {
    description = "C++ implementation of the MCAP file format";
    homepage = "https://github.com/foxglove/mcap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phodina ];
    platforms = lib.platforms.all;
  };
})
