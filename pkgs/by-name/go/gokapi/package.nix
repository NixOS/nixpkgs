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
    mainProgram = "gokapi";
  };
}
