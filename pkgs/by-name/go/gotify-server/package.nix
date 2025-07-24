{
  lib,
  fetchFromGitHub,
  buildGoModule,
  sqlite,
  callPackage,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotify-server";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9vIReA29dWf3QwUYEW8JhzF9o74JZqG4zGobgI+gIWE=";
  };

  vendorHash = "sha256-rs6EfnJT6Jgif2TR5u5Tp5/Ozn+4uhSapksyKFnQiCo=";

  # No test
  doCheck = false;

  buildInputs = [
    sqlite
  ];

  ui = callPackage ./ui.nix { inherit (finalAttrs) src version; };

  # Use preConfigure instead of preBuild to keep goModules independent from ui
  preConfigure = ''
    cp -r ${finalAttrs.ui} ui/build
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "ui"
      ];
    };
    tests = {
      nixos = nixosTests.gotify-server;
    };
  };

  # Otherwise, all other subpackages are built as well and from some reason,
  # produce binaries which panic when executed and are not interesting at all
  subPackages = [ "." ];

  # Based on LD_FLAGS in upstream's .github/workflows/build.yml:
  # https://github.com/gotify/server/blob/v2.6.3/.github/workflows/build.yml#L33
  ldflags = [
    "-s"
    "-X main.Version=${finalAttrs.version}"
    "-X main.Mode=prod"
    "-X main.Commit=refs/tags/v${finalAttrs.version}"
    "-X main.BuildDate=unknown"
  ];

  meta = {
    description = "Simple server for sending and receiving messages in real-time per WebSocket";
    homepage = "https://gotify.net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "server";
  };
})
