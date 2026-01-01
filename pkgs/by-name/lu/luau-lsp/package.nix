{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luau-lsp";
<<<<<<< HEAD
  version = "1.59.0";
=======
  version = "1.56.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "JohnnyMorganz";
    repo = "luau-lsp";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-hd1yQ+VJenmBk2WIjO7tFdoyJ8jIq6248ljz9T6c4Vc=";
=======
    hash = "sha256-lEv4ZysuYrK86JRoH8M2PesGEo7LI9ybGLIOExPtTZQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" stdenv.hostPlatform.darwinArch)
  ];

  nativeBuildInputs = [ cmake ];

  buildPhase = ''
    runHook preBuild

    cmake --build . --target Luau.LanguageServer.CLI --config Release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D luau-lsp $out/bin/luau-lsp

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server Implementation for Luau";
    homepage = "https://github.com/JohnnyMorganz/luau-lsp";
    downloadPage = "https://github.com/JohnnyMorganz/luau-lsp/releases/tag/${finalAttrs.version}";
    changelog = "https://github.com/JohnnyMorganz/luau-lsp/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      anninzy
      HeitorAugustoLN
    ];
    mainProgram = "luau-lsp";
    platforms = lib.platforms.all;
    badPlatforms = [
      # Could not find a package configuration file provided by "Protobuf"
      # It is unclear why this is only happening on x86_64-darwin
      "x86_64-darwin"
    ];
  };
})
