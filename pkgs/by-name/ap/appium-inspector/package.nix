{ fetchFromGitHub
, buildNpmPackage
, makeWrapper
, electron_13
, copyDesktopItems
, makeDesktopItem
, nix-update-script
, stdenv
, lib
}:
let
  electron = electron_13;
in buildNpmPackage rec {
  pname = "appium-inspector";
  version = "2024.3.1";

  patches = [ ./Fix-Open-File.patch ];

  src = fetchFromGitHub {
    owner = "appium";
    repo = "appium-inspector";
    rev = "v${version}";
    hash = "sha256-X384CjAX3glsPpXqc6Rht6OqXB8imclwXv26tYaYfxk=";
  };

  npmDepsHash = "sha256-9/wf/psbn9uZ+9ZYTSV4IKjgprWYaMSYorVgStR9yVU=";
  npmFlags = ["--ignore-scripts"];

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];

  installPhase = ''
    mkdir -p "$out/share/appium-inspector"

    cp -r './node_modules' "$out/share/appium-inspector/node_modules"
    cp -r './dist' "$out/share/appium-inspector/"
    cp './package.json' "$out/share/appium-inspector/package.json"

    # executable wrapper
    makeWrapper '${electron}/bin/electron' "$out/bin/appium-inspector" \
      --add-flags "$out/share/appium-inspector/dist/main.js" \
      --set NODE_ENV production
  '';

  desktopItem = makeDesktopItem {
    name = "appium-inspector";
    exec = "appium-inspector %u";
    desktopName = "Appium Inspector";
    comment = meta.description;
    categories = [ "Development" ];
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A GUI inspector for mobile apps and more, powered by a (separately installed) Appium server";
    homepage = "https://appium.github.io/appium-inspector";
    license = lib.licenses.asl20;
    mainProgram = "appium-inspector";
    maintainers = with lib.maintainers; [ marie ];
    inherit (electron.meta) platforms;
  };
}
