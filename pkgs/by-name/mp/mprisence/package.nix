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
  version = "1.2.14";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-prRnDQvBewgeaHZGonwnRHoVgbSgo9FINsUu4LoI078=";
  };

  cargoHash = "sha256-yL6b6X7OHuiILDowTsWdvTvftO2p6KmfmFQ1UxHjsAg=";

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
