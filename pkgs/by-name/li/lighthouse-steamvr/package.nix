{
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "Lighthouse";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = "Lighthouse";
    rev = finalAttrs.version;
    hash = "sha256-c3AEoNpuPqCn37WIDVbJDX61qM6Pg/f6sMro3M/skNc=";
  };

  cargoHash = "sha256-Kow/M7FDgaZiLcWU9se5ut3lrVOtAZebQTgURzSORsA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];
  buildFeatures = [ "cli" ];

  meta = {
    description = "VR Lighthouse power state management";
    homepage = "https://github.com/ShayBox/Lighthouse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "lighthouse";
  };
})
