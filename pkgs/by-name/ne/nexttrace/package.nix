{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "nxtrace";
    repo = "NTrace-core";
    rev = "v${version}";
    sha256 = "sha256-UmViXxyOvzs2ifG7y+OA+/BjzbF6YIc6sjDUN+ttS8w=";
  };
  vendorHash = "sha256-rSCg6TeCVdYldghmFCXtv2R9mQ97b3DogZhFcSTzt4o=";

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
