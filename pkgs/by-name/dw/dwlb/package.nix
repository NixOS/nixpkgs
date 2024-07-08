{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  pkg-config,
  wayland,
  wayland-protocols,
  pixman,
  fcft,
  # Boolean flags
  withCustomConfigH ? (configH != null),
  # Configurable options
  configH ? null,
}:
assert withCustomConfigH -> configH != null;
stdenv.mkDerivation {
  pname = "dwlb";
  version = "0-unstable-2024-05-17";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "dwlb";
    rev = "0daa1c1fdd82c4d790e477bf171e23ca2fdfa0cb";
    hash = "sha256-Bu20IqRwBP1WRBgbcEQU4Q2BZ2FBnVaySOTsCn0iSSE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    wayland
    wayland-protocols
    pixman
    fcft
  ];

  outputs = [
    "out"
    "man"
  ];

  # Allow alternative config.def.h usage. Taken from dwl.nix.
  postPatch =
    let
      configFile =
        if lib.isDerivation configH || builtins.isPath configH then
          configH
        else
          writeText "config.h" configH;
    in
    lib.optionalString withCustomConfigH "cp ${configFile} config.h";

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A fast, feature-complete bar for dwl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lonyelon ];
    inherit (wayland.meta) platforms;
    mainProgram = "dwlb";
  };
}
