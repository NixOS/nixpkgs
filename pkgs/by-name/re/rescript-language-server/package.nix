{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  esbuild,
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

  rescript-editor-analysis = callPackage ../../../applications/editors/vscode/extensions/chenglou92.rescript-vscode/rescript-editor-analysis.nix { inherit version; };
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

  nativeBuildInputs = [ esbuild ];

  # Tries to do funny things (install all packages for the entire repo) if you don't override it. This is just a copy paste
  # from the package.json.
  buildPhase = ''
    runHook preBuild

    npm install
    mkdir analysis_binaries/${platformDir}
    cp ${rescript-editor-analysis}/bin/rescript-editor-analysis analysis_binaries/${platformDir}/rescript-editor-analysis.exe
    esbuild src/cli.ts --bundle --sourcemap --outfile=out/cli.js --format=cjs --platform=node --loader:.node=file --minify

    runHook postBuild
  '';

  meta = {
    description = "ReScript Language Server";
    homepage = "https://github.com/rescript-lang/rescript-vscode/tree/master/server";
    mainProgram = "rescript-language-server";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = [ ];
  };
}
