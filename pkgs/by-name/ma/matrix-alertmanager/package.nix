{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage rec {
  pname = "matrix-alertmanager";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jaywink";
    repo = "matrix-alertmanager";
    rev = "v${version}";
    hash = "sha256-t5e9UfRtt1OzxEXuMkPLW352BbAVSLEt26fo5YppQQc=";
  };

  postPatch = ''
    ${lib.getExe jq} '. += {"bin": "src/app.js"}' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  npmDepsHash = "sha256-4UYX9ndqecr06/gZeouzrDss6568jBXY1ypcVX7DEVk=";

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
