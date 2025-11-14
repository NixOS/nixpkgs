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
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M0UfdUw65PD3HuKAh6PbbuNzyHVbYUfMuQT8em6OnaM=";
  };

  cargoHash = "sha256-STvMAkCFrMjekz2wk2UtEi6nsEVFnuIhFinxWWbcIto=";

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
