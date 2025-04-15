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
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "Forceu";
    repo = "Gokapi";
    tag = "v${version}";
    hash = "sha256-RDEvKh3tUun7wt1nhtCim95wEN9V9RlztZ9zcw9nS1o=";
  };

  vendorHash = "sha256-9GRAlgng+yq7q0VQz374jIOCjeDIIDD631BglM/FsQQ=";

  # This is the go generate is ran in the upstream builder, but we have to run the components separately for things to work.
  preBuild = ''
    cd ./cmd/gokapi/
    go run ../../build/go-generate/updateVersionNumbers.go
    # Tries to download "golang.org/x/exp/slices"
    # go run ../../build/go-generate/updateProtectedUrls.go
    go run ../../build/go-generate/buildWasm.go
    # Must be specify go root to import wasm_exec.js
    GOROOT="$(go env GOROOT)" go run "../../build/go-generate/copyStaticFiles.go"
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
