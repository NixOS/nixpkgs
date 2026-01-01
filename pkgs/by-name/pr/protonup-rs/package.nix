{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protonup-rs";
<<<<<<< HEAD
  version = "0.9.3";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-GpKiecfEV66TGgU3f/WlQZZ4mVJD4+quZSb+45fsWpM=";
  };

  cargoHash = "sha256-15K6n7npZmbxDroIN09Tr5L8oTUJ0js9/cfiPQDeTTQ=";
=======
  version = "0.9.2";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-mysYcBmXKkXz1vlhZv8okVnnD83h/QyGwT9ijluOgms=";
  };

  cargoHash = "sha256-NiJwaD7lH2jnxfc/Hreo3bJ3LC+0UAOlsVMt1UYRcdY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  checkFlags = [
    # Requires internet access
    "--skip=downloads::tests"
  ];

  meta = {
    description = "Rust app to install and update GE-Proton for Steam, and Wine-GE for Lutris";
    homepage = "https://github.com/auyer/Protonup-rs";
    changelog = "https://github.com/auyer/Protonup-rs/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      joshprk
    ];
    mainProgram = "protonup-rs";
  };
})
