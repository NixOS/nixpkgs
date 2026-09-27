{
  lib,
  fetchFromGitHub,
  just,
  libcosmicAppHook,
  nix-update-script,
  rustPlatform,
  stdenv,
  udev,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-osk";
  version = "1.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-osk";
    rev = "38e962576f1893e6452d4c273c41149c432191b2";
    hash = "sha256-9lLzO+s1o3Vj68cEnqE6wnke89ZDargZxlz7vY5VsBk=";
  };

  cargoHash = "sha256-r5XlNx1GIy4gEiHX9QVYLEufRnuwxe9X4OBbz3tinIo=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    libcosmicAppHook
    just
  ];
  buildInputs = [
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cargo-target-dir"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-osk";
    description = "On screen keyboard for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-files";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cosmic ];
  };
}
