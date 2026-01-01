{
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oci2git";
<<<<<<< HEAD
  version = "0.2.5";
=======
  version = "0.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Virviil";
    repo = "oci2git";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-il0u5SDFbY7NqBvfHeeIvJ2NPXms9wi+/hujYBINdcw=";
  };

  cargoHash = "sha256-NuB0moVXOu2P19idPPp9v4LoqUZyz1r74Mh8y6V/dPg=";
=======
    hash = "sha256-83Rcw4K3+bqcvqoXTQ2ay/7eAO6GT76RV3qFzfX6O60=";
  };

  cargoHash = "sha256-7OallIrRg278Bo9iV7FStXbZ1W29RuAK6AnB3PQNWrY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Introspecting Docker images as easy as using Git";
    homepage = "https://github.com/Virviil/oci2git";
    changelog = "https://github.com/Virviil/oci2git/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.kpbaks ];
    mainProgram = "oci2git";
    platforms = lib.platforms.all;
  };
})
