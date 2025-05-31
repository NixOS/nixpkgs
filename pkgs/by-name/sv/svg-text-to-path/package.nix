{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "svg-text-to-path";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "paulzi";
    repo = "svg-text-to-path";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1LW4jYRawP+BM1UtFJiTdcWVnFsEtRdVMlpZgbpZZ8Q=";
  };

  npmDepsHash = "sha256-HBV002dwyWwb9dBBpQY4FFZ/U0lfrXNEmNz4Aa0gRKw=";
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
