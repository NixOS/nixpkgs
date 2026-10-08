{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "cadvisor";
  version = "0.56.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UBQvFlO0pb5mDUrrUTaEsuQcKX7qKQrAMub2knUZWGA=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-JJulf+Wj/bf3l8l0rufcyLlfqefriOzhxCfGUru6+lA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/google/cadvisor/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/{cmd,cadvisor}
    rm $out/bin/example
  '';

  passthru.tests = { inherit (nixosTests) cadvisor; };

  meta = {
    description = "Analyzes resource usage and performance characteristics of running docker containers";
    mainProgram = "cadvisor";
    homepage = "https://github.com/google/cadvisor";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
