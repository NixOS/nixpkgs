{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "ddns-updater";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "qdm12";
    repo = "ddns-updater";
    rev = "v${version}";
    hash = "sha256-K9zD5aIM+HpLM//crjkK5PU2QEa7Git++LHNtgWE6Vk=";
  };

  vendorHash = "sha256-twv2xMyVAs0Xue8GADlJITaPek/AsCvkJbQcJmEc7ts=";

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "cmd/updater" ];

  postInstall = ''
    mv $out/bin/updater $out/bin/ddns-updater
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Container to update DNS records periodically with WebUI for many DNS providers";
    homepage = "https://github.com/qdm12/ddns-updater";
    license = licenses.mit;
    maintainers = with maintainers; [ delliott ];
    mainProgram = "ddns-updater";
  };
}
