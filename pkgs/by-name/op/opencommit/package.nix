{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  npm-lockfile-fix,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "opencommit";
  version = "3.3.12";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5mI7D+KUXkLLuRi18IqI+xOiW49YKNbvG6MkAzbfl6I=";
    postFetch = ''
      # Fix lockfile issues with bundled dependencies
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-m4TtvXOffgJV6ZlhGLslnllOdRTl4Q5EriE6r24QYVI=";

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    npm run test:unit
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate git commit messages with an LLM";
    homepage = "https://github.com/di-sukharev/opencommit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "oco";
  };
})
