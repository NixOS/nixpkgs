{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "cadvisor";
  version = "0.52.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    hash = "sha256-LNnL3vxt5ZEstyriRggVyLGOFim0eMT0XH4SgBaZLx0=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-ttfLCPG5DFJbh0v5BUUDwdEaw7itu8qTIqxeYEowB44=";

  ldflags = [ "-s" "-w" "-X github.com/google/cadvisor/version.Version=${version}" ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

  passthru.tests = { inherit (nixosTests) cadvisor; };

  meta = with lib; {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    mainProgram = "cadvisor";
    homepage = "https://github.com/google/cadvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
