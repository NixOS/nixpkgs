{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "cadvisor";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${version}";
    hash = "sha256-caGzjv7XhIst3JZA0ri97XqQOO3mI+hwS8WJmLk9f7g=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-xUhHo/kDnjAQLuaeFG1EouC2FWBnFhj1RawlQX7ggVs=";

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
