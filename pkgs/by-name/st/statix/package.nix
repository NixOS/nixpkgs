{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "statix";
  # also update version of the vim plugin in
  # pkgs/applications/editors/vim/plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "oppiliappan";
    repo = "statix";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-bMs3XMiGP6sXCqdjna4xoV6CANOIWuISSzCaL5LYY4c=";
  };

  cargoHash = "sha256-Pi1q2qNLjQYr3Wla7rqrktNm0StszB2klcfzwAnF3tE=";

  buildFeatures = lib.optional withJson "json";

  # tests are failing on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/oppiliappan/statix";
    license = lib.licenses.mit;
    mainProgram = "statix";
    maintainers = with lib.maintainers; [
      nerdypepper
      progrm_jarvis
    ];
  };
})
