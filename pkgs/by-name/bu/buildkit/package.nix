{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "buildkit";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "moby";
    repo = "buildkit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DJ/nA8EPEx7OQBScP1LupOlMXgpsWXSJaBXdTgtyTg0=";
  };

  vendorHash = null;

  subPackages = [ "cmd/buildctl" ] ++ lib.optionals stdenv.hostPlatform.isLinux [ "cmd/buildkitd" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/moby/buildkit/version.Version=${finalAttrs.version}"
    "-X github.com/moby/buildkit/version.Revision=${finalAttrs.src.rev}"
  ];

  doCheck = false;

  meta = {
    description = "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit";
    homepage = "https://github.com/moby/buildkit";
    changelog = "https://github.com/moby/buildkit/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      vdemeester
    ];
    mainProgram = "buildctl";
  };
})
