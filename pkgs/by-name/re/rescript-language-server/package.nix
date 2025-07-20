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
  platformDir =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "darwin"
    else if stdenv.hostPlatform.isFreeBSD then
      "freebsd"
    else if stdenv.hostPlatform.isWindows then
      "win32"
    else
      throw "Unsupported system: ${stdenv.system}";
in
buildNpmPackage (finalAttrs: {
  # These have the same source, and must be the same version.
  inherit (rescript-editor-analysis) src version;
  pname = "rescript-language-server";

  sourceRoot = "${finalAttrs.src.name}/server";

  npmDepsHash = "sha256-Qi41qDJ0WR0QWw7guhuz1imT51SqI7mORGjNbmZWnio";

  strictDeps = true;
  nativeBuildInputs = [ esbuild ];

  # Tries to do funny things (install all packages for the entire repo) if you don't override it. This is just a copy paste
  # from the package.json.
  buildPhase = ''
    runHook preBuild

    # https://github.com/rescript-lang/rescript-vscode/blob/1.62.0/package.json#L252
    esbuild src/cli.ts --bundle --sourcemap --outfile=out/cli.js --format=cjs --platform=node --loader:.node=file --minify

    runHook postBuild
  '';

  postInstall = ''
    DIR="$out/lib/node_modules/@rescript/language-server/analysis_binaries/${platformDir}"

    mkdir -p "$DIR"
    ln -s ${lib.getExe rescript-editor-analysis} "$DIR"/rescript-editor-analysis
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "([0-9]+\.[0-9]+\.[0-9]+)"
    ];
  };

  meta = {
    description = "ReScript Language Server";
    homepage = "https://github.com/rescript-lang/rescript-vscode/tree/${finalAttrs.version}/server";
    changelog = "https://github.com/rescript-lang/rescript-vscode/releases/tag/${finalAttrs.version}";
    mainProgram = "rescript-language-server";
    license = lib.licenses.mit;
    # https://github.com/rescript-lang/rescript-vscode/blob/1.62.0/CONTRIBUTING.md?plain=1#L186
    platforms = with lib.platforms; linux ++ darwin ++ windows ++ freebsd;
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
})
