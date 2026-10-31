{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "noqtis";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "rootcoder007";
    repo = "noqtis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jiCgvIiaSLg44JoPkyujDsq2AijACveXhl2BVxUJ0Po=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "NQSHARED" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "NQWERROR" false)
    (lib.cmakeBool "NQOSSL" false)
  ];

  doCheck = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Post-quantum signing, KEMs and sealed input records in C11";
    homepage = "https://github.com/rootcoder007/noqtis";
    changelog = "https://github.com/rootcoder007/noqtis/blob/v${finalAttrs.version}/NEWS.md";
    license = with lib.licenses; [
      asl20
      llvm-exception
    ];
    maintainers = with lib.maintainers; [ rootcoder007 ];
    mainProgram = "noqtis";
    platforms = lib.platforms.unix;
  };
})
