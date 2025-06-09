{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "nxtrace";
    repo = "NTrace-core";
    rev = "v${version}";
    sha256 = "sha256-S3rxA5V3x4xdfUiq+XnP2ObE2gQ/3IcooIx6ShNkLrc=";
  };
  vendorHash = "sha256-9CNreBLmx1t95M8BijfytDxDrr/GL1GPI/ed9SdYae4=";

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nxtrace/NTrace-core/config.Version=v${version}"
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
    # Broken on darwin for Go toolchain > 1.22, with error:
    # 'link: github.com/nxtrace/NTrace-core/trace/internal: invalid reference to net.internetSocket'
    broken = stdenv.hostPlatform.isDarwin;
  };
}
