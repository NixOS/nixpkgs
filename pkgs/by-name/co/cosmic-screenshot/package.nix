{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  just,
  pkg-config,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-screenshot";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-/sGYF+XWmPraNGlBVUcN/nokDB9JwWViEAL9gVH3ZaI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1r0Uwcf4kpHCgWqrUYZELsVXGDzbtbmu/WFeX53fBiQ=";

  nativeBuildInputs = [
    just
    pkg-config
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-screenshot"
  ];

  passthru.tests = {
    inherit (nixosTests)
      cosmic
      cosmic-autologin
      cosmic-noxwayland
      cosmic-autologin-noxwayland
      ;
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = teams.cosmic.members;
    platforms = platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
})
