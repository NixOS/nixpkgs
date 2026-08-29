{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ...
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oniri";
  version = "1.2.1";
  rev = "v${finalAttrs.version}";
  __structuredAttrs = true;
  srcHash = "sha256-ficdMooufOXx2mUOGzn1R9YoxvySs4Tz9s0DMZ5crUM=";
  cargoHash = "sha256-dYtRl4YX2zVaNcwpiwEjfVJcU4NGHvXkqsl+TqgMLP8=";

  src = fetchFromGitHub {
    owner = "Antiz96";
    repo = finalAttrs.pname;
    hash = finalAttrs.srcHash;
    inherit (finalAttrs) rev;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "A tool that automatically maximizes the only window of a niri workspace";
    homepage = "https://github.com/Antiz96/oniri";
    license = lib.licenses.gpl3;
    mainProgram = "oniri";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      zaphyra
    ];
  };
})
