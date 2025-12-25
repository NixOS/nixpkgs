{
  pkgs,
  lib,
  fetchFromGitHub,
  testers,
  argonaut,
}:

pkgs.buildGoModule (finalAttrs: {
  pname = "argonaut";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "darksworm";
    repo = "argonaut";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-AE39NM8FkfuD6V32GYh02RrqQM4uaZPL2IgtZE6ceMA=";
  };

  vendorHash = "sha256-xln/WmZbi0+rHqMMHRgt0ar/EaBDNscCsd/NckJZnMw=";
  proxyVendor = true;
  subPackages = [ "cmd/app" ];
  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.buildDate=1970-01-01T00:00:00Z"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = argonaut;
      command = "HOME=$(mktemp -d) argonaut --version";
      inherit (finalAttrs) version;
    };
  };

  # Skip tests as Nix has limited network access
  checkFlags = [
    "-skip=TestLoadPool|TestNewHTTP"
  ];
  postInstall = ''
    mv $out/bin/app $out/bin/argonaut
  '';

  meta = with pkgs.lib; {
    description = "Keyboard-first terminal UI for Argo CD";
    homepage = "https://github.com/darksworm/argonaut";
    changelog = " https://github.com/darksworm/argonaut/releases/tag/v ${finalAttrs.version}";
    license = licenses.gpl3Only;
    mainProgram = "argonaut";
    maintainers = with lib.maintainers; [
      ehrenschwan-gh
    ];
  };
})
