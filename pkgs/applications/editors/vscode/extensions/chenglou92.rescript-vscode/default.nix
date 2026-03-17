{
  lib,
  stdenv,
  vscode-utils,
  ocamlPackages,
  fetchFromGitHub,
  _experimental-update-script-combinators,
  nix-update-script,
}:
let
  version = "1.72.0";

  rescript-editor-analysis = ocamlPackages.buildDunePackage (finalAttrs: {
    pname = "analysis";
    inherit version;

    minimalOCamlVersion = "4.10";

    src = fetchFromGitHub {
      owner = "rescript-lang";
      repo = "rescript-vscode";
      tag = finalAttrs.version;
      hash = "sha256-bGCQ/HC6ItQMR0v0wLsF9pNX/Y1sBnp7E+Am0flWhGk=";
    };

    strictDeps = true;
    nativeBuildInputs = [
      ocamlPackages.cppo
    ];

    passthru.updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "([0-9]+\\.[0-9]+\\.[0-9]+)"
      ];
    };

    meta = {
      description = "Analysis binary for the ReScript VSCode plugin";
      homepage = "https://github.com/rescript-lang/rescript-vscode";
      changelog = "https://github.com/rescript-lang/rescript-vscode/releases/tag/${finalAttrs.version}";
      maintainers = with lib.maintainers; [
        jayesh-bhoot
        RossSmyth
      ];
      license = lib.licenses.mit;
      mainProgram = "rescript-editor-analysis";
    };
  });

  arch =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "darwin"
    else
      throw "Unsupported system: ${stdenv.system}";
  analysisDir = "server/analysis_binaries/${arch}";
in

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "rescript-vscode";
    publisher = "chenglou92";
    inherit version;
    hash = "sha256-yUAhysTM9FXo9ZAzrto+tnjnofIUEQAGBg3tjIainrY=";
  };

  strictDeps = true;
  postPatch = ''
    rm -r ${analysisDir}
    ln -s ${rescript-editor-analysis}/bin ${analysisDir}
  '';

  passthru = {
    # For rescript-language-server
    inherit rescript-editor-analysis;
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        attrPath = "vscode-extensions.chenglou92.rescript-vscode.rescript-editor-analysis";
        extraArgs = [
          "--version-regex"
          "([0-9]+\\.[0-9]+\\.[0-9]+)"
        ];
      })
      (nix-update-script {
        extraArgs = [
          "--version"
          "skip"
        ];
      })
      (nix-update-script {
        attrPath = "rescript-language-server";
        extraArgs = [
          "--version"
          "skip"
        ];
      })
    ];
  };

  meta = {
    description = "Official VSCode plugin for ReScript";
    homepage = "https://github.com/rescript-lang/rescript-vscode";
    maintainers = [
      lib.maintainers.jayesh-bhoot
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.mit;
  };
}
