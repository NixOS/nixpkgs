{
  lib,
  stdenv,
  buildNpmPackage,
  clang_20,
  fetchFromGitHub,
  libsecret,
  nodejs-slim,
  pkg-config,
}:

buildNpmPackage (finalAttrs: {
  pname = "azurite";
  version = "3.37.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "Azurite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gqWwUpUKaMzc9TiIhgubak+NQCX9dvqLQDg6Eysaw14=";
  };

  npmDepsHash = "sha256-ZgYGURSFc/4xx6QqJA5wMFzbWSaAH39ztcfBEqCfmVg=";

  nativeBuildInputs = [
    pkg-config
    nodejs-slim.python
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ clang_20 ]; # clang_21 breaks @vscode/vsce's optional dependency keytar

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libsecret
  ];

  # @vscode/vsce-sign's postinstall script fails on exotic architectures.
  # We ignore the scripts, and this does not change the output.
  npmFlags = [ "--ignore-scripts" ];

  meta = {
    description = "Lightweight server clone of Azure Storage that simulates most of the commands supported by it with minimal dependencies";
    homepage = "https://github.com/Azure/Azurite";
    license = lib.licenses.mit;
    mainProgram = "azurite";
    maintainers = with lib.maintainers; [
      danielalvsaaker
    ];
  };
})
