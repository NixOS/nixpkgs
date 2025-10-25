{
  lib,
  stdenv,
  cmakeMinimal,
  fetchFromGitHub,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openzl";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "openzl";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-oL0ajfedlLu0cfXbzpzG8D3cJ3zaB+AfX5BvpHDhv2Q=";
  };

  nativeBuildInputs = [
    cmakeMinimal
    ninja
  ];

  cmakeFlags = [
    "-GNinja"
  ];

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  postInstall = ''
    install -D cli/zli* $bin/bin/zli
    install -D tools/sddl/sddl_compiler* $bin/bin/sddl_compiler
  '';

  meta = {
    description = "Graph-based data compression framework";
    homepage = "https://openzl.org";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.theoparis ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/facebook/openzl/blob/${finalAttrs.src.tag}/CHANGELOG";
    mainProgram = "zli";
  };
})
