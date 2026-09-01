{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nixosTests,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ddns-updater";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "qdm12";
    repo = "ddns-updater";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E/ToeY5O6GaMl0ItLbNNF5Uur0Gx87FdT0T4kekae88=";
  };

  vendorHash = "sha256-osrRxiifxYgcxShso6HnxBCDQPMUiwfbt6fVipjkmdE=";

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "cmd/ddns-updater" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/ddns-updater \
      --set GODEBUG "netdns=go"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) ddns-updater;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Container to update DNS records periodically with WebUI for many DNS providers";
    homepage = "https://github.com/qdm12/ddns-updater";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delliott ];
    mainProgram = "ddns-updater";
  };
})
