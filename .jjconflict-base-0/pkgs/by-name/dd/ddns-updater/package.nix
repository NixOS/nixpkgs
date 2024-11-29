{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
  nix-update-script,
}:
buildGoModule rec {
  pname = "ddns-updater";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "qdm12";
    repo = "ddns-updater";
    rev = "v${version}";
    hash = "sha256-U8Vw7dsj/efqvpooT3QQjNp41AuGYJ/Gz/pA8Em3diE=";
  };

  vendorHash = "sha256-M9Al3zl2Ltv4yWdyRB3+9zpTr3foliu5WweImHltz3M=";

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "cmd/updater" ];

  passthru = {
    tests = {
      inherit (nixosTests) ddns-updater;
    };
    # nixpkgs-update: no auto update
    # Necessary only as rryantm keeps getting confused and thinks 2.6.1 is newer than 2.7.0
    # TODO remove once version newer than 2.7.0 is released
    updateScript = nix-update-script { };
  };

  postInstall = ''
    mv $out/bin/updater $out/bin/ddns-updater
  '';

  meta = with lib; {
    description = "Container to update DNS records periodically with WebUI for many DNS providers";
    homepage = "https://github.com/qdm12/ddns-updater";
    license = licenses.mit;
    maintainers = with maintainers; [ delliott ];
    mainProgram = "ddns-updater";
  };
}
