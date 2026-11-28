{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clap-validator";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-validator";
    rev = finalAttrs.version;
    hash = "sha256-4GmmZIMRoPUEbsT34iCaOWRhYmhMonF9BXnc/rFQV0M=";
  };

  cargoHash = "sha256-m6VebZM8jVm22Xk8URpHF+UAHOJWYC74Ha3bpFuz1VU=";

  checkFlags = [
    # Disabled failing tests because the test plugins expect a directory layout
    # not present in the build environment and therefore failed to build.
    "--skip=fuzz_clack_effect"
    "--skip=fuzz_clack_synth"
    "--skip=validate_clack_effect"
    "--skip=validate_clack_synth"
  ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/free-audio/clap-validator/releases/tag/${finalAttrs.version}";
    description = "Development tooling for validation of CLAP audio plugins";
    homepage = "https://github.com/free-audio/clap-validator";
    license = lib.licenses.mit;
    mainProgram = "clap-validator";
    maintainers = [ lib.maintainers.ginkogruen ];
  };
})
