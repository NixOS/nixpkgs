{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,

  # tests
  callPackage,
}:

buildGoModule (finalAttrs: {
  pname = "dutctl";
  version = "1.0.0-alpha.2-unstable-2026-08-25";

  src = fetchFromGitHub {
    owner = "BlindspotSoftware";
    repo = "dutctl";
    rev = "c402b399acc1c6425ce9afe8b02e10e6c2c2f382";
    hash = "sha256-OoVaZU95tE4zY4z5Yin2c5ezfRsP8WTc7eCuXpGOC2A=";
  };

  vendorHash = "sha256-jg5UNZ15OZsLfGG0LXouNvBwQ2NX+dzP0cQBHAdgUds=";

  ldflags = [
    "-s"
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };

    tests = callPackage ./test.nix {
      dutctl = finalAttrs.finalPackage;
    };
  };

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Unified device management for open firmware development";
    longDescription = ''
      dutctl stands for "Device-under-Test Control" and is an open-source
      command-line utility and service ecosystem for managing development and
      test devices in firmware environments.

      By providing a unified interface to interact with boards and test
      fixtures across platforms, dutctl eliminates the fragmentation of device
      management tools that has long plagued firmware workflows.

      The project features remote device control, command streaming,
      multi-architecture testing, and a flexible plugin architecture for
      extensibility.
    '';
    homepage = "https://github.com/BlindspotSoftware/dutctl";
    changelog = "https://github.com/BlindspotSoftware/dutctl/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "dutctl";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
