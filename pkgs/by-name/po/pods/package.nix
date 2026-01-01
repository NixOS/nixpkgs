{
  lib,
  stdenv,
  fetchFromGitHub,
  applyPatches,
  fetchpatch2,
  cargo,
  desktop-file-utils,
  glib,
  gtk4,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  gtksourceview5,
  libadwaita,
  libpanel,
  vte-gtk4,
  versionCheckHook,
  nix-update-script,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "pods";
  version = "2.2.0";

  src = applyPatches {
    name = "pods-patched";
    src = fetchFromGitHub {
      owner = "marhkb";
      repo = "pods";
<<<<<<< HEAD
      tag = "v${finalAttrs.version}";
=======
      tag = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      hash = "sha256-m+0XjxY0nDAJbVX3r/Jfg+G+RU8Q51e0ZXxkdH69SiQ=";
    };

    # Based on upstream PR: https://github.com/marhkb/pods/pull/895
    # which cannot be merged into 2.2.0 because dependencies were bumped since its release.
    # Hopefully 2.2.1 will be released soon
    patches = [ ./cve-2025-62516.patch ];
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
<<<<<<< HEAD
    inherit (finalAttrs) pname version src;
=======
    inherit pname version src;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-GBWaGCNXYCiT/favrIYB30VGMMoQQk1iUh4GTNPerK8=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk4
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    libadwaita
    libpanel
    vte-gtk4
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Podman desktop application";
    homepage = "https://github.com/marhkb/pods";
<<<<<<< HEAD
    changelog = "https://github.com/marhkb/pods/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms = lib.platforms.linux;
    mainProgram = "pods";
  };
})
=======
    changelog = "https://github.com/marhkb/pods/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "pods";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
