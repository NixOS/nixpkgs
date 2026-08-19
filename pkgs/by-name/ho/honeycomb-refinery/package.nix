{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "honeycomb-refinery";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "refinery";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fip02kKy+LLySFVBI/cKMEZdQRus+4dXBUfm0yGlBlc=";
  };

  env.NO_REDIS_TEST = true;

  patches = [
    # Allows turning off the one test requiring a Redis service during build.
    # We could in principle implement that, but it's significant work to little
    # payoff.
    ./0001-add-NO_REDIS_TEST-env-var-that-disables-Redis-requir.patch
  ];

  excludedPackages = [
    "LICENSES"
    "cmd/test_redimem"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.BuildID=${finalAttrs.version}"
  ];

  vendorHash = "sha256-5TWPbtmY3f8Wpvs5GblNOmTwFxEeL7dKKWvA6jGClhs=";

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/honeycombio/refinery";
    description = "Tail-sampling proxy for OpenTelemetry";
    mainProgram = "refinery";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jkachmar
      lf-
    ];
  };
})
