{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "glider";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "nadoo";
    repo = "glider";
    rev = "v${version}";
    hash = "sha256-LrIHdI1/55llENjDgFJxh2KKsJf/tLT3P9L9jhLhfS0=";
  };

  vendorHash = "sha256-v/HJUah+QC34hcf9y5yRSFO8OTkqD2wzdOH/wIXrKoA=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    substituteInPlace systemd/glider@.service \
      --replace-fail "/usr/bin/glider" "$out/bin/glider"
    install -Dm444 -t "$out/lib/systemd/system/" systemd/glider@.service
  '';

  meta = with lib; {
    homepage = "https://github.com/nadoo/glider";
    description = "Forward proxy with multiple protocols support";
    license = licenses.gpl3Only;
    mainProgram = "glider";
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
  };
}
