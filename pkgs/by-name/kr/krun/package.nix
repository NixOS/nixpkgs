{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  libkrun,
  makeWrapper,
  passt,
  sommelier,
  mesa,
  withSommelier ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "krun";
  version = "0-unstable-2024-06-18";

  src = fetchFromGitHub {
    owner = "slp";
    repo = pname;
    rev = "912afa5c6525b7c8f83dffd65ec4b1425b3f7521";
    hash = "sha256-rDuxv3UakAemDnj4Nsbpqsykts2IcseuQmDwO24L+u8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/AsahiLinux/muvm/commit/622e177d51d3d162f46bd5c46524e7c391c55764.diff";
      hash = "sha256-CV69L+VDDLRcWgpgDCAYKLlTU9ytFcHhzNgOibWD8KY=";
    })
    (fetchpatch {
      url = "https://github.com/AsahiLinux/krun/commit/41abb0b0be8d4c7604b132a0e9c7f2db92c12d57.diff";
      hash = "sha256-cK3iDhh+33H16V65lWUXahjmpSxI1HhiLUmkjfkRB7A=";
    })
  ];

  cargoHash = "sha256-NahnigxJaY2QwWnySCRrnf3JyqZ+7jRA1CpE7ON0OOE=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    (libkrun.override {
      withGpu = true;
      withNet = true;
    })
  ];

  # Allow for sommelier to be disabled as it can cause problems.
  wrapArgs = [
    "--prefix PATH : ${lib.makeBinPath (lib.optional withSommelier [ sommelier ] ++ [ passt ])}"
  ];

  postFixup = ''
    wrapProgram $out/bin/krun $wrapArgs \
      --set-default OPENGL_DRIVER ${mesa.driverLink}
  '';

  meta = {
    description = "Run programs from your system in a microVM";
    homepage = "https://github.com/slp/krun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    platforms = libkrun.meta.platforms;
    mainProgram = "krun";
  };
}
