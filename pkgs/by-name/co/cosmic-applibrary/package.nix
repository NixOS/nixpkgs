{
  fetchFromGitHub,
  just,
  lib,
  libcosmicAppHook,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-applibrary";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-applibrary";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-FA2KMwU3KTFNomIGQBKnNNixfzTk8KWs+FhHBb0UR+o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+TbKXdB2RFJi1OPIaczq0pSAq8Z7dXxchUu1xmA2GH8=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-app-library"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-applibrary";
    description = "Application Template for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-app-library";

    maintainers = with maintainers; [
      nyabinary
      thefossguy
    ];
  };
}
