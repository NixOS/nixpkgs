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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-session";
  version = "1.0.0-alpha.6";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-session";
    tag = "epoch-${finalAttrs.version}";
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

  meta = {
    homepage = "https://github.com/pop-os/cosmic-session";
    description = "Session manager for the COSMIC desktop environment";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-session";
    maintainers = with lib.maintainers; [
      a-kenji
      nyabinary
      thefossguy
    ];
    platforms = lib.platforms.linux;
  };
})
