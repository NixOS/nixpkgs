{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkgs,
}:

buildGoModule (finalAttrs: {
  pname = "aeroflare";
  version = "1.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "itzemoji";
    repo = "aeroflare";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8R+9/1DNkQg/hS6Mpc9rswK+rUkUUJpWYWfkThRLMJE=";
  };

  vendorHash = "sha256-H4jgc08mklolpHQNlcQx5JzpCDBYpujgoKFR2Ct8xR8=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/itzemoji/aeroflare/internal/build.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/aeroflare"
    "cmd/aeroflare-ci"
  ];
  versionCheckProgramArg = "version";

  meta = with lib; {
    description = "OCI-based Nix-Binary-Cache written in Go";
    homepage = "https://github.com/itzemoji/aeroflare";
    changelog = "https://github.com/itzemoji/aeroflare/blob/${finalAttrs.version}/CHANGELOG.md";
    platforms = platforms.unix;
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ itzemoji ];
    mainProgram = "aeroflare";
  };
})
