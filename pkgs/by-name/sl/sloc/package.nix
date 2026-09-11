{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  testers,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "sloc";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "flosse";
    repo = "sloc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YDrJn/NSXa1LcFK1bxVQF5Qp/Ru38JTszZUMBiK3PPI=";
  };

  npmDepsHash = "sha256-cFUWwmsYy75qAfhkY6tc4Hxwjo8WJcC5urQC22UnnVU=";

  postPatch =
    let
      lockfile = fetchurl {
        url = "https://raw.githubusercontent.com/flosse/sloc/e26044011821c4e170859362f2de657d64118711/package-lock.json";
        hash = "sha256-yWVErql5SWOSbbw2DZUlXBJp7zqZngkc8uAC5ZfnjX0=";
      };
    in
    ''
      if [ -e ./package-lock.json ]; then
        echo "Remove postPatch!"
        exit 1
      else
        cp ${lockfile} ./package-lock.json
      fi
    '';

  npmBuildScript = "prepublish";

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    npm test

    runHook postCheck
  '';

  passthru = {
    tests = {
      wrapped = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple tool to count SLOC (source lines of code)";
    homepage = "https://github.com/flosse/sloc";
    changelog = "https://github.com/flosse/sloc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomodachi94 ];
    mainProgram = "sloc";
    platforms = lib.platforms.all;
  };
})
