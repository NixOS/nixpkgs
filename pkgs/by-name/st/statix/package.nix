{
  lib,
  rustPlatform,
  fetchFromGitHub,
  withJson ? true,
  stdenv,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
=======
}:

rustPlatform.buildRustPackage rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "statix";
  # also update version of the vim plugin in
  # pkgs/applications/editors/vim/plugins/overrides.nix
  # the version can be found in flake.nix of the source code
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "oppiliappan";
    repo = "statix";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    rev = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sha256 = "sha256-bMs3XMiGP6sXCqdjna4xoV6CANOIWuISSzCaL5LYY4c=";
  };

  cargoHash = "sha256-Pi1q2qNLjQYr3Wla7rqrktNm0StszB2klcfzwAnF3tE=";

  buildFeatures = lib.optional withJson "json";

  # tests are failing on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "Lints and suggestions for the nix programming language";
    homepage = "https://github.com/oppiliappan/statix";
    license = licenses.mit;
    mainProgram = "statix";
    maintainers = with maintainers; [
      nerdypepper
    ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
