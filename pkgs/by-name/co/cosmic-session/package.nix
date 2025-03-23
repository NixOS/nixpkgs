{
  lib,
  fetchFromGitHub,
  bash,
  rustPlatform,
  just,
  dbus,
  stdenv,
  xdg-desktop-portal-cosmic,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-session";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    rev = "epoch-${version}";
    hash = "sha256-2EKkVdZ7uNNJ/E/3knmeH3EBa+tkYmIxP3t9d6yacww=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iYObxjWJUKgZKGTkqtYgQK4758k0EYZGhIAM/oLxxso=";

  postPatch = ''
    substituteInPlace Justfile \
      --replace-fail '{{cargo-target-dir}}/release/cosmic-session' 'target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-session'
    substituteInPlace data/start-cosmic \
      --replace-fail '/usr/bin/cosmic-session' "${placeholder "out"}/bin/cosmic-session" \
      --replace-fail '/usr/bin/dbus-run-session' "${lib.getBin dbus}/bin/dbus-run-session"
    substituteInPlace data/cosmic.desktop \
      --replace-fail '/usr/bin/start-cosmic' "${placeholder "out"}/bin/start-cosmic"
  '';

  buildInputs = [ bash ];
  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "cosmic_dconf_profile"
    "cosmic"
  ];

  env.XDP_COSMIC = "${xdg-desktop-portal-cosmic}/libexec/xdg-desktop-portal-cosmic";

  passthru.providedSessions = [ "cosmic" ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC desktop environment";
    license = licenses.gpl3Only;
    mainProgram = "cosmic-session";
    maintainers = with maintainers; [
      a-kenji
      nyabinary
      thefossguy
    ];
    platforms = platforms.linux;
  };
}
