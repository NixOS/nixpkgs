{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildGoModule,
  callPackage,
  gnumake,
  pnpm_9,
  nodejs,
  ocis,
}:
let
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
  version = "5.0.9";

  vendorHash = null;

  src = fetchFromGitHub {
    owner = "owncloud";
    repo = "ocis";
    tag = "v${version}";
    hash = "sha256-TsMrQx+P1F2t66e0tGG0VvRi4W7+pCpDHd0aNsacOsI=";
  };

  nativeBuildInputs = [
    gnumake
    nodejs
    pnpm_9.configHook
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    sourceRoot = "${src.name}/services/idp";
    fetcherVersion = 1;
    hash = "sha256-gNlN+u/bobnTsXrsOmkDcWs67D/trH3inT5AVQs3Brs=";
  };
  pnpmRoot = "services/idp";

  buildPhase = ''
    runHook preBuild
    cp -r ${ocis.web}/share/* services/web/assets/
    pnpm -C services/idp build

    mkdir -p services/idp/assets/identifier/static
    cp -r ${idp-assets}/share/* services/idp/assets/identifier/static/

    make -C ocis VERSION=${version} DATE=${version} build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/
    cp ocis/bin/ocis $out/bin/
    runHook postInstall
  '';

  passthru = {
    web = callPackage ./web.nix { };
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://github.com/owncloud/web";
    description = "Next generation frontend for ownCloud Infinite Scale";
    license = lib.licenses.asl20;
    mainProgram = "ocis";
    maintainers = with lib.maintainers; [ xinyangli ];
  };
}
