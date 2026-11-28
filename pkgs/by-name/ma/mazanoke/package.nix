{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
}:
let
  version = "1.1.5";
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "mazanoke";
  src = fetchFromGitHub {
    owner = "civilblur";
    repo = "mazanoke";
    tag = "v${version}";
    hash = "sha256-B/AF4diMNxN94BzpZP/C+K8kNj9q+4SDKWa/qd4LrVU=";
  };
  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/mazanoke
    cp ./index.html ./favicon.ico ./manifest.json ./service-worker.js $out/share/mazanoke
    cp -r ./assets $out/share/mazanoke/assets

    runHook postBuild
  '';
  meta = {
    homepage = "https://MAZANOKE.com";
    description = "Self-hosted local image optimizer that runs in your browser";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jolheiser ];
  };
}
