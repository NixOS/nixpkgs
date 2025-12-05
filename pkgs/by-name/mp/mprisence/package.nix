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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-edjpaYXrY3DCwY8jqXAeqR5GJgWirx9w4lNGMgYHvJU=";
  };

  cargoHash = "sha256-AqEYb20W2atVwnAAMtXSLP4x/KwRfcWidNTAINXUpjw=";

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
