{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gokapi";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Forceu";
    repo = "Gokapi";
    tag = "v${version}";
    hash = "sha256-GEdg79Rl4MqaVIJz9fAVs02hN270SIStq54fvxzL7UU=";
  };

  vendorHash = "sha256-gP9bCnRN40y7NWwh3V8dv1yOBqpmzlcp8Bf6IkdjoWU=";

  patches = [ ];

  # This is the go generate is ran in the upstream builder, but we have to run the components separately for things to work.
  preBuild = ''
    # Some steps expect GOROOT to be set.
    export GOROOT="$(go env GOROOT)"
    # Go generate runs from this working dir upstream
    cd ./cmd/gokapi/
    go run ../../build/go-generate/updateVersionNumbers.go
    # Tries to download "golang.org/x/exp/slices", and fails
    # go run ../../build/go-generate/updateProtectedUrls.go
    go run ../../build/go-generate/buildWasm.go
    go run ../../build/go-generate/copyStaticFiles.go
    # Attempts to download program to minify content, and fails
    # go run ../../build/go-generate/minifyStaticContent.go
    go run ../../build/go-generate/updateApiRouting.go
    cd ../..
  '';

  subPackages = [
    "cmd/gokapi"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = {
      inherit (nixosTests) gokapi;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lightweight selfhosted Firefox Send alternative without public upload";
    homepage = "https://github.com/Forceu/Gokapi";
    changelog = "https://github.com/Forceu/Gokapi/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      delliott
    ];
    knownVulnerabilities = [
      (
        "The following vulnerabilities have been fixed in gokapi 2.2.3 "
        + "(which is in Nixpkgs unstable), but cannot be included in the stable "
        + "release due to breaking changes:"
      )
      "CVE-2026-28683"
      "CVE-2026-29060"
      "CVE-2026-29061"
      "CVE-2026-29084"
      "CVE-2026-28682"
      (
        "The following vulnerabilities have been fixed in gokapi 2.2.4 "
        + "(which is in Nixpkgs unstable), but cannot be included in the stable "
        + "release due to breaking changes:"
      )
      "CVE-2026-30955"
      "CVE-2026-30961"
      "CVE-2026-30943"
    ];
    mainProgram = "gokapi";
  };
}
