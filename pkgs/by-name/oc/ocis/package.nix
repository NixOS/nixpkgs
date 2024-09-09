{
  lib,
  stdenvNoCC,
  callPackage,
  fetchFromGitHub,
  buildGoModule,
  gnumake,
  pnpm,
  nodejs,
}:
let
  web = callPackage ./web.nix { };
  idp-assets = stdenvNoCC.mkDerivation {
    pname = "idp-assets";
    version = "0-unstable-2020-10-14";
    src = fetchFromGitHub {
      owner = "owncloud";
      repo = "assets";
      rev = "e8b6aeadbcee1865b9df682e9bd78083842d2b5c";
      hash = "sha256-PzGff2Zx8xmvPYQa4lS4yz2h+y/lerKvUZkYI7XvAUw=";
    };
    installPhase = ''
      mkdir -p $out/share
      cp logo.svg favicon.ico $out/share/
    '';
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;
  };
in
buildGoModule rec {
  pname = "ocis";
  version = "v5.0.7";

  vendorHash = null;

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "ocis";
    rev = version;
    hash = "sha256-vCEr7UCGEPm0x04U8DpsUNz9c64ZSEIK4SDcitCIDCw=";
  };

  nativeBuildInputs = [
    gnumake
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    sourceRoot = "${src.name}/services/idp";
    hash = "sha256-ojrgoyl+xBsgEsx3d3gv5Wf6ziabHoFkEpAoDZcYavo=";
  };
  pnpmRoot = "services/idp";

  buildPhase = ''
    runHook preBuild
    cp -r ${web}/share/* services/web/assets/
    pnpm -C services/idp build

    mkdir -p services/idp/assets/identifier/static
    cp -r ${idp-assets}/share/* services/idp/assets/identifier/static/

    make -C ocis VERSION=${version} DATE=${version} build
    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp ocis/bin/ocis $out/bin/
  '';

  passthru = {
    inherit web;
  };

  meta = with lib; {
    homepage = "https://github.com/owncloud/ocis";
    description = "ownCloud Infinite Scale Stack";
    mainProgram = "ocis";
    license = licenses.asl20;
    maintainers = with maintainers; [ xinyangli ];
  };
}
