{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "cadvisor";
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    hash = "sha256-N8qSYuB2+BWVm6u2iFpl+b9sbj8EgH9YwUa3mCNhkRQ=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-OAnuJfwndKBDX6mVw5P7t/vOKmWf+qApqmCKyl/MSqs=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/google/cadvisor/version.Version=${version}"
  ];

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
