{
  fetchFromGitHub,
  fontconfig,
  freetype,
  just,
  lib,
  libcosmicAppHook,
  libinput,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-term";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-term";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-DK60/eZscSnLet+UPB+Gv/KMB10URntnLlAn4z81Ijs=";
  };
  # Match this to the git commit SHA matching the `src.rev`
  env.VERGEN_GIT_SHA = "77be96e1c20039511e29da4ba5b8ce457e098f3b";
  # Match this to the commit date of `src.rev` in the format 'YYYY-MM-DD'
  env.VERGEN_GIT_COMMIT_DATE = "2024-12-04";

  useFetchCargoVendor = true;
  cargoHash = "sha256-cybLKkScLN4ElTSAf2pODb9wEQxBCdS0qeyZjs/rdCM=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-term"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-term";
    description = "Terminal for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-term";

    maintainers = with maintainers; [
      ahoneybun
      nyabinary
      thefossguy
    ];
  };
}
