{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  pkg-config,
  dbus,
  openssl,
  aws-lc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mprisence";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "lazykern";
    repo = "mprisence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NcHUEwAPfB1olyJ0D3fjpJcmgmMyew0hKAYPJpNFV+4=";
  };

  cargoHash = "sha256-9lVHV2R+Di4R2FAEhZ9IG0gsgBThLf9+oJEJLUJ/9ZM=";

  # Required for some of the tests
  __darwinAllowLocalNetworking = true;
  nativeCheckInputs = [ cacert ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    dbus
    openssl
    aws-lc
  ];

  meta = {
    description = "Highly customizable Discord Rich Presence for MPRIS media players on Linux";
    homepage = "https://github.com/lazykern/mprisence";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toasteruwu ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    mainProgram = "mprisence";
  };
})
