{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage rec {
  pname = "matrix-alertmanager";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jaywink";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GwASazYgZTYrMn696VL+JKEjECoCKxr2VWj2zae8U/E=";
  };

  postPatch = ''
    ${lib.getExe jq} '. += {"bin": "src/app.js"}' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-LCbImn0EGbTtB30IjLU+tjP38BQdk5Wozsl3EgOrcs8=";

  dontNpmBuild = true;

  meta = with lib; {
    changelog = "https://github.com/jaywink/matrix-alertmanager/blob/${src.rev}/CHANGELOG.md";
    description = "Bot to receive Alertmanager webhook events and forward them to chosen rooms";
    mainProgram = "matrix-alertmanager";
    homepage = "https://github.com/jaywink/matrix-alertmanager";
    license = licenses.mit;
    maintainers = with maintainers; [ erethon ];
  };
}
