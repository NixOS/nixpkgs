{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cordova";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "cordova-cli";
    rev = version;
    hash = "sha256-fEV7NlRcRpyeRplsdXHI2U4/89DsvKQpVwHD5juiNPo=";
  };

  npmDepsHash = "sha256-ZMxZiwCgqzOBwDXeTfIEwqFVdM9ysWeE5AbX7rUdwIc=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Build native mobile applications using HTML, CSS and JavaScript";
    homepage = "https://github.com/apache/cordova-cli";
    license = licenses.asl20;
    mainProgram = "cordova";
    maintainers = with maintainers; [ flosse ];
  };
}
