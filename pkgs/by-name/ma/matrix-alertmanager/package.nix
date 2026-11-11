{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "matrix-alertmanager";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "jaywink";
    repo = "matrix-alertmanager";
    rev = "v${version}";
    hash = "sha256-kdz5KyT0ZIbiq6MMVAQBPjz2QP1kcNWtEv10/RzH/14=";
  };

  postPatch = ''
    ${lib.getExe jq} '. += {"bin": "src/app.js"}' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-r1OvxCk6dgVAb3NKxveTr/1PTRFYQVDhQmBHbikzALE=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/jaywink/matrix-alertmanager/blob/${src.rev}/CHANGELOG.md";
    description = "Bot to receive Alertmanager webhook events and forward them to chosen rooms";
    mainProgram = "matrix-alertmanager";
    homepage = "https://github.com/jaywink/matrix-alertmanager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erethon ];
  };
}
