{
  fetchFromGitHub,
  just,
  lib,
  libcosmicAppHook,
  rustPlatform,
  stdenv,
  which,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-notifications";
  version = "1.0.0-alpha.4";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-notifications";
    rev = "refs/tags/epoch-1.0.0-alpha.4";
    hash = "sha256-bc2CqdAEnYXbLofKLO3g9DsK8OzolK2pwhaIDaXKjSY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-KQWGJlyONZDsY8DMkmQ3X2kggLw1WcIAc8wzYTwmCnU=";

  nativeBuildInputs = [
    just
    libcosmicAppHook
    which
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-notifications"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-notifications";
    description = "Notifications for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "cosmic-notifications";

    maintainers = with maintainers; [
      nyabinary
      thefossguy
    ];
  };
}
