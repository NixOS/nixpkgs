{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "nxtrace";
    repo = "NTrace-core";
    rev = "v${version}";
    sha256 = "sha256-Etz/MXTFpcHbpha8WEmbhHtvyrrVhlLZDfc+J3j6o6M=";
  };
  vendorHash = "sha256-jJJXQIv91IkUhIIyMlZUxnx6LzPEtgbjizhDGUu9ZZE=";

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
