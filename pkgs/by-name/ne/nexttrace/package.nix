{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "nxtrace";
    repo = "NTrace-core";
    rev = "v${version}";
    sha256 = "sha256-Ui3Vm9Q6VJXW9hGDFCuOCUmoSO8SE5ufRYq0niY6ojo=";
  };
  vendorHash = "sha256-8KxY3KYcaaZZjk+IIKdu8tzGhgGUlJ5nyMMSKhe41kg=";

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nxtrace/NTrace-core/config.Version=v${version}"
    "-checklinkname=0" # refers to https://github.com/nxtrace/NTrace-core/issues/247
  ];

  postInstall = ''
    mv $out/bin/NTrace-core $out/bin/nexttrace
  '';

  meta = with lib; {
    description = "Open source visual route tracking CLI tool";
    homepage = "https://mtr.moe";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sharzy ];
    mainProgram = "nexttrace";
  };
}
