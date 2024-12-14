{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  dbip-country-lite,
  nix-update-script,
}:

buildGoModule rec {
  pname = "nezha";
  version = "0.20.13";

  src = fetchFromGitHub {
    owner = "naiba";
    repo = "nezha";
    rev = "refs/tags/v${version}";
    hash = "sha256-fJvL2cESQoiW93aj2RHPyZXvP8246Mf8hIRiP/DSRRY=";
  };

  postPatch = ''
    cp ${dbip-country-lite.mmdb} pkg/geoip/geoip.db
  '';

  patches = [
    # Nezha originally used ipinfo.mmdb to provide geoip query feature.
    # Unfortunately, ipinfo.mmdb must be downloaded with token.
    # Therefore, we patch the nezha to use dbip-country-lite.mmdb in nixpkgs.
    ./dbip.patch
  ];

  vendorHash = "sha256-SYefkgc0CsAEdkL7rxu9fpz7dpBnx1LwabIadUeOKco=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/naiba/nezha/service/singleton.Version=${version}"
  ];

  checkFlags = "-skip=^TestSplitDomainSOA$";

  postInstall = ''
    mv $out/bin/dashboard $out/bin/nezha
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hosted, lightweight server and website monitoring and O&M tool";
    homepage = "https://github.com/naiba/nezha";
    changelog = "https://github.com/naiba/nezha/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "nezha";
  };
}
