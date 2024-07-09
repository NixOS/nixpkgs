{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pingtunnel";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "esrrhs";
    repo = "pingtunnel";
    rev = version;
    hash = "sha256-qkIeE6gNBUUd5/IhcKhDmXZbzeSTR0r6qCAK/Nz7Kew=";
  };

  vendorHash = "sha256-SkBHFvQn3Q6fl/d1npEspTYhq1YrnusXNWr/Ky4bv64=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/pingtunnel
  '';

  meta = with lib; {
    description = "Tool that send TCP/UDP traffic over ICMP";
    homepage = "https://github.com/esrrhs/pingtunnel";
    license = licenses.mit;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "pingtunnel";
  };
}
