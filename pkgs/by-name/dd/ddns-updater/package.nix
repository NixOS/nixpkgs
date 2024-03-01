{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "ddns-updater";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "qdm12";
    repo = "ddns-updater";
    rev = "v${version}";
    hash = "sha256-NU6KXVjggsXVCKImGqbB1AXcph+ycRfkk5S4JNq0cHg=";
  };

  vendorHash = "sha256-Ibrv0m3Tz/5JbkHYmiJ9Ijo37fjHc7TP100K7ZTwO8I=";

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [ "cmd/updater" ];

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
