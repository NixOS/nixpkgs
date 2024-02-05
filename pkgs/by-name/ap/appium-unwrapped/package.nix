{ fetchFromGitHub, buildNpmPackage, yq-go, lib, nodejs, fetchpatch }:
let
  version = "2.4.1";
in buildNpmPackage {
  pname = "appium-unwrapped";
  inherit version;

  patches = [
    # appium checks for a writable directory, this fails because the nix store is read-only
    ./Disable-writable.patch
    # Lockfile fix backport, remove when upstream has a working lockfile
    (fetchpatch {
      url = "https://github.com/NyCodeGHG/appium/commit/db713322d6d7c3de28a2f960f54e0e0b2bfab13c.patch";
      hash = "sha256-v9fm/MryXxjJ0uAkt2/ZNiD3URvl6ImsuqopgMGWOuI=";
    })
  ];

  src = fetchFromGitHub {
    owner = "appium";
    repo = "appium";
    rev = "appium@${version}";
    hash = "sha256-pJzrnhJRTpMgFOYuSiq7DuTBfNyFGcWw3yUOijY7mhw=";
  };

  npmDepsHash = "sha256-kTNnjpcYMkxJZ9jDhTYA+mJ7rbmGvo8qqr/OrN/E9vs=";

  nativeBuildInputs = [ yq-go ];

  npmFlags = [ "--ignore-scripts" ];

  preConfigure = ''
    yq -iPo json '. + {"bin": {"appium":"packages/appium/index.js"}}' ./package.json
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
