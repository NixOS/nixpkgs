{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "cadvisor";
  version = "0.60.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cadvisor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j/QImeIRafeRmtZMZAtyaee81uJk8t/Ij3MEUpQMuwo=";
  };

  modRoot = "./cmd";

  vendorHash = "sha256-lkxftA6LOzI73xHza3t0/SINfZM3UmtTiJu2gVe0/F0=";

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
    maintainers = [ lib.maintainers.lukas-sgx ];
    platforms = lib.platforms.linux;
  };
})
