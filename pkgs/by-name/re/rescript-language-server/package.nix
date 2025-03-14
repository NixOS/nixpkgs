{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  esbuild,
  nix-update-script,
  versionCheckHook,
  rescript-editor-analysis,
}:
let
  version = "1.62.0";

  platformDir =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "darwin"
    else
      throw "Unsupported system: ${stdenv.system}";
in
buildNpmPackage rec {
  pname = "rescript-language-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rescript-vscode";
    tag = version;
    hash = "sha256-Tox5Qq0Kpqikac90sQww2cGr9RHlXnVy7GMnRA18CoA=";
  };

  sourceRoot = "${src.name}/server";
  npmDepsHash = "sha256-Qi41qDJ0WR0QWw7guhuz1imT51SqI7mORGjNbmZWnio=";

  strictDeps = true;
  nativeBuildInputs = [ esbuild ];

  # Tries to do funny things (install all packages for the entire repo) if you don't override it. This is just a copy paste
  # from the package.json.
  buildPhase = ''
    runHook preBuild

    # https://github.com/rescript-lang/rescript-vscode/blob/1.62.0/.github/workflows/ci.yml#L182-L183
    mkdir analysis_binaries/${platformDir}
    cp ${lib.getExe rescript-editor-analysis} analysis_binaries/${platformDir}/

    # https://github.com/rescript-lang/rescript-vscode/blob/1.62.0/package.json#L252
    esbuild src/cli.ts --bundle --sourcemap --outfile=out/cli.js --format=cjs --platform=node --loader:.node=file --minify

    runHook postBuild
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ReScript Language Server";
    homepage = "https://github.com/rescript-lang/rescript-vscode/tree/${version}/server";
    changelog = "https://github.com/rescript-lang/rescript-vscode/releases/tag/${version}";
    mainProgram = "rescript-language-server";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ lib.maintainers.RossSmyth ];
  };
}
