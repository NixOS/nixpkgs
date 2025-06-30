{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atar";
  version = "0.1.25";

  src = fetchFromGitHub {
    owner = "x71c9";
    repo = "atar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aMOovfJ9Srex/dBHz7hRMYmDkCbpXPOFHjU+VM/qqi8=";
  };

  cargoHash = "sha256-6q+0YQeY38tVQdnJw3x80binLw4dLQNGNMX0PH/+KjA=";

  meta = {
    description = "Ephemeral Terraform runner that applies a configuration on start, displays output variables, and automatically destroys all resources on exit or failure";
    homepage = "https://github.com/x71c9/atar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x71c9 ];
    mainProgram = "atar";
  };
})
