{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "pm2";
  version = "6.0.8";

  src = fetchFromGitHub {
    owner = "Unitech";
    repo = "pm2";
    rev = "v${version}";
    hash = "sha256-roSHLJsDeNAa9z9O/hgy9P4ho5zeLz1+w0a8U0Ix2ao=";

    # Requested patch upstream: https://github.com/Unitech/pm2/pull/5985
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-6xUGO1vrzU5pi33ZaiRB6L5gY8p7ES93effyGdhsV5o=";

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
