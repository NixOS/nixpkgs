{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprisence";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I/rY8EU7EHlxtKO/++itjkDehGSIOHmU0C1PJGsgvHA=";
  };

  cargoHash = "sha256-ZAr+cdC/A5YsPTdZhKF1qPM37oavXyIDhZYPAQ3zq8A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    openssl
  ];

  meta = with lib; {
    description = "Highly customizable Discord Rich Presence for MPRIS media players on Linux";
    homepage = "https://github.com/lazykern/mprisence";
    license = licenses.mit;
    maintainers = with maintainers; [ toasteruwu ];
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "mprisence";
  };
})
