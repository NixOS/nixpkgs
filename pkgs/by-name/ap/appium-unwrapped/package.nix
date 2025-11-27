{
  fetchFromGitHub,
  buildNpmPackage,
  yq-go,
  lib,
  nodejs,
}:
let
  version = "3.1.1";
in
buildNpmPackage {
  pname = "appium-unwrapped";
  inherit version;

  patches = [
    # appium checks for a writable directory, this fails because the nix store is read-only
    ./Disable-writable.patch
  ];

  src = fetchFromGitHub {
    owner = "appium";
    repo = "appium";
    rev = "appium@${version}";
    hash = "sha256-SdnWrnkCyFSdS5KO99uxqO1s9N60IaxhRrMQHsg43EA=";
  };

  npmDepsHash = "sha256-bwjIBphk/+A0F3k7nClDXAVnX7D/o7LvCr8whCBLLdA=";

  # Lockfile fix backport, remove when upstream has a working lockfile
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
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
    maintainers = with lib.maintainers; [ marie ];
    inherit (nodejs.meta) platforms;
  };
}
