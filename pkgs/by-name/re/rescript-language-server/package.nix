{
  rescript-editor-analysis,
  lib,
  callPackage,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  esbuild,
}:

let
  version = "1.60.0";

  platformDir =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "darwin"
    else
      throw "Unsupported system: ${stdenv.system}";

in
buildNpmPackage rec {
  inherit version;

  pname = "rescript-language-server";

  src = fetchFromGitHub {
    tag = version;
    owner = "rescript-lang";
    repo = "rescript-vscode";
    hash = "sha256-w5YIK+dfZcZDnrocB/H+D0Gpxmpm7q/wW5piZY/ZCcI=";
  };

  sourceRoot = "${src.name}/server";
  npmDepsHash = "sha256-BqdXpyVc0ECbr+UcivRW0zPPHwJjKgUmpnf8j7ZXJOg=";

  nativeBuildInputs = [ esbuild ];

  # Tries to do funny things (install all packages for the entire repo) if you don't override it. This is just a copy paste
  # from the package.json.
  buildPhase = ''
    npm install
    mkdir analysis_binaries/${platformDir}
    cp ${rescript-editor-analysis}/bin/rescript-editor-analysis analysis_binaries/${platformDir}/rescript-editor-analysis.exe
    esbuild src/cli.ts --bundle --sourcemap --outfile=out/cli.js --format=cjs --platform=node --loader:.node=file --minify
  '';

  meta = with lib; {
    description = "ReScript Language Server";
    homepage = "https://github.com/rescript-lang/rescript-vscode/tree/master/server";
    mainProgram = "rescript-language-server";
    license = licenses.mit;
    maintainers = [ ];
  };
}
