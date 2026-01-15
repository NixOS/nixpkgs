{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
  version = "0-unstable-2026-01-07";

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
    rev = "a6a3e5202c579664010c2776ca0b3d1a6d035b69";
    hash = "sha256-xUN/aHcAzA2DDzitZV+kEVfGgADOSCsY0zJLiRdTAQg=";
  };

  vendorHash = "sha256-rruIjtXtFZ0MOJkWx4n+7apKGv4Pq6GrOWoQ3o+8KFs=";

  subPackages = [ "cmd/pkgsite" ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Official tool to extract and generate documentation for Go projects like pkg.go.dev";
    homepage = "https://github.com/golang/pkgsite";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "pkgsite";
  };
}
