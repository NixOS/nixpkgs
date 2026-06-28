{
  fetchFromGitHub,
  buildNpmPackage,
  yq-go,
  lib,
  nodejs,
}:
let
  version = "3.5.2";
in
buildNpmPackage {
  pname = "appium-unwrapped";
  inherit version;

  src = fetchFromGitHub {
    owner = "appium";
    repo = "appium";
    rev = "appium@${version}";
    hash = "sha256-Mku4mbCo14NYGc5xfXFgw1IjfI4X+gKvDFdOIbyvgHE=";
  };

  npmDepsHash = "sha256-UOhdNhjSmvrTHR7JbQw8bgftRPUGunnIu5QZufnuJhg=";

  # Lockfile fix backport, remove when upstream has a working lockfile
  postPatch = ''
    cp ${./package-lock.json} package-lock.json

    substituteInPlace packages/appium/lib/bootstrap/appium-initializer.ts \
      --replace-fail 'await requireDir(appiumHome, true, appiumHomeSourceName);' 'await requireDir(appiumHome, false, appiumHomeSourceName);' 
  '';

  nativeBuildInputs = [ yq-go ];

  npmFlags = [ "--ignore-scripts" ];

  preConfigure = ''
    yq -iPo json '. + {"bin": {"appium":"packages/appium/index.js"}}' ./package.json
  '';

  preInstall = ''
    sed -i '/build/d' .gitignore
  '';

  meta = {
    homepage = "https://appium.io";
    description = "Open-source automation framework that provides WebDriver-based automation possibilities for a wide range of different mobile, desktop and IoT platforms";
    license = lib.licenses.asl20;
    mainProgram = "appium";
    maintainers = with lib.maintainers; [
      eyjhb
      marie
    ];
    inherit (nodejs.meta) platforms;
  };
}
