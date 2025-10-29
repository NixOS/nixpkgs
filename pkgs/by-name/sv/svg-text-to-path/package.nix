{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "svg-text-to-path";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "paulzi";
    repo = "svg-text-to-path";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ArAv/8JLQKdM3Lqdyx8XETPq3b6QcDwpwonpgoGlp9E=";
  };

  npmDepsHash = "sha256-hY8YrhvMlvcnLCVolhnnZHHq81fsOHyDgHlhyWeTEL0=";
  npmPackFlags = [ "--ignore-scripts" ];
  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Convert svg nodes to vector font-free elements";
    homepage = "https://github.com/paulzi/svg-text-to-path";
    maintainers = with lib.maintainers; [ ulysseszhan ];
    license = lib.licenses.mit;
    mainProgram = "svg-text-to-path";
    platforms = lib.platforms.unix;
  };
})
