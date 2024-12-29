{
  fetchFromGitHub,
  glib,
  just,
  lib,
  libcosmicAppHook,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-files";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-O7O03ksks4Rp4kUtYHzmoaIGLleA8yAxPIjapylR+ao=";
  };
  # Match this to the git commit SHA matching the `src.rev`
  env.VERGEN_GIT_SHA = "2fa8e6adc44448bd5ac749302154f8f670e7f381";
  # Match this to the commit date of `src.rev` in the format 'YYYY-MM-DD'
  env.VERGEN_GIT_COMMIT_DATE = "2024-12-04";

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZuKb654nfSt+v50l07z8uVAVP52IxCZG4Z2qDfyM6pk=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
  ];

  buildInputs = [ glib ];
  cargoBuildFlags = [ "--package" "cosmic-files" "--package" "cosmic-files-applet" ];
  cargoTestFlags = [ "--package" "cosmic-files" "--package" "cosmic-files-applet" ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
    "--set"
    "applet-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files-applet"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-files";

    maintainers = with maintainers; [
      ahoneybun
      nyabinary
      thefossguy
    ];
  };
}
