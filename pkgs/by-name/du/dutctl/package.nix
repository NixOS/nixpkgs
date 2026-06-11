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
  version = "1.0.0-alpha.1-unstable-2026-06-03";

  src = fetchFromGitHub {
    owner = "BlindspotSoftware";
    repo = "dutctl";
    rev = "f2b5ea834299c5716a90662549fcef64408df0f9";
    hash = "sha256-lw8qkhXt2ZpgyZdfpJVLxr/7UxTcmhFg3fXKI/z9F40=";
  };

  vendorHash = "sha256-vOBz9gi/cnUJ04ns1ZOgfNqzbVBE3Fd3oOfV04VSmFQ=";

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
