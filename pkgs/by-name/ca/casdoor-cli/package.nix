{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "1.1.0";
in
buildGoModule (finalAttrs: {
  pname = "casdoor-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "casdoor";
    repo = "casdoor-cli";
    tag = "v${version}";
    hash = "sha256-73vA2bGbnk6FPZWUzgT2IroXfwTvv49MLvLzvkbCriI=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-A8cqbuEKeebi9qWswhMBblqmXa3zcepMaQ7uKxQVzjY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/casdoor/casdoor-cli/internal/cli.Version=${finalAttrs.version}"
  ];

  # The CLI is a pure Go program without any cgo dependency, so the binary
  # links statically. Upstream's goreleaser build does the same.
  env.CGO_ENABLED = 0;

  # Upstream builds the binary as "casdoor", which collides with the binary of
  # the casdoor server package. Rename it to match the package name.
  postInstall = ''
    mv $out/bin/casdoor $out/bin/casdoor-cli
  '';

  # The tests only exercise the CLI's own logic, they do not need a Casdoor
  # server or network access.
  doCheck = true;

  meta = {
    description = "Command line interface for Casdoor";
    homepage = "https://github.com/casdoor/casdoor-cli";
    changelog = "https://github.com/casdoor/casdoor-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "casdoor-cli";
    maintainers = with lib.maintainers; [ ser ];
    platforms = lib.platforms.unix;
  };
})
