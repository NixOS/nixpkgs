{
  fetchFromGitHub,
  fontconfig,
  freetype,
  glib,
  gtk3,
  just,
  lib,
  libcosmicAppHook,
  libinput,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-edit";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-edit";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-IAIO5TggPGzZyfET2zBKpde/aePXR4FsSg/Da1y3saA=";
  };
  # Match this to the git commit SHA matching the `src.rev`
  env.VERGEN_GIT_SHA = "86bcadb9e7502642ecaa0cd8d50313eff632f843";
  # Match this to the commit date of `src.rev` in the format 'YYYY-MM-DD'
  env.VERGEN_GIT_COMMIT_DATE = "2024-12-04";

  useFetchCargoVendor = true;
  cargoHash = "sha256-pRp6Bi9CcHg2tMAC86CZybpfGL2BTxzst3G31tXJA5A=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    glib
    gtk3
    libinput
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-edit"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-edit";
    description = "Text Editor for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-edit";

    maintainers = with maintainers; [
      ahoneybun
      nyabinary
      thefossguy
    ];
  };
}
