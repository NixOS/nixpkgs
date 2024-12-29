{
  bash,
  fetchFromGitHub,
  just,
  lib,
  libcosmicAppHook,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-idle";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-idle";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-+BOzbFDEoIaYkXs48RJtfomv8qdzIFiEpDpN/zDDgFM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-v5ClhxWtzgo4nerz8AxOnboRJRbe6U06cDlLtBe2kr8=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-idle"
  ];

  postPatch = ''
    substituteInPlace src/main.rs --replace-fail '"/bin/sh"' '"${lib.getExe bash}"'
  '';

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-idle";
    description = "Idle daemon for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-idle";

    maintainers = with maintainers; [
      thefossguy
    ];
  };
}
