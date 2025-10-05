{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "pm2";
  version = "6.0.13";

  src = fetchFromGitHub {
    owner = "Unitech";
    repo = "pm2";
    rev = "v${version}";
    hash = "sha256-Tvwx6yqNH1Ab30DCT18HtHAp/ruTJFult4bvFzKTy7Y=";

    # Requested patch upstream: https://github.com/Unitech/pm2/pull/5985
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-2+onHdd8BvSTOavXw32vAId7Epd+1Y7OM95DBslcR2o=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/Unitech/pm2/blob/${src.rev}/CHANGELOG.md";
    description = "Node.js production process manager with a built-in load balancer";
    homepage = "https://github.com/Unitech/pm2";
    license = lib.licenses.agpl3Only;
    mainProgram = "pm2";
    maintainers = with lib.maintainers; [ jeremyschlatter ];
  };
}
