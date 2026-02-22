{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "sif";
  version = "0-unstable-2026-02-13";

  src = fetchFromGitHub {
    owner = "vmfunc";
    repo = "sif";
    rev = "03bfe70cff2249cef6e52679aba3d411916a4dd1";
    hash = "sha256-tIV9h5kaXq4CKDDexSxiDXcWD2l510qXt5BBxwFV8Nw=";
  };

  vendorHash = "sha256-kbFNnPf8A4dtTnk/XBArgM6yOE2gbW6mXR5oevkQ6Ms=";

  subPackages = [ "cmd/sif" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  # network-dependent tests
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=(0-unstable-.*)"
    ];
  };

  meta = {
    description = "Modular pentesting toolkit written in Go";
    homepage = "https://github.com/vmfunc/sif";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vmfunc ];
    mainProgram = "sif";
  };
}
