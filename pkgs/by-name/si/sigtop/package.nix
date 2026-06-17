{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:

buildGoModule (finalAttrs: {
  pname = "sigtop";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HxU0A5t+O3414dIK/dmL1tUz3M7qrN4nQpEQfSmzhmc=";
  };

  vendorHash = "sha256-qUXevafaUDxtaj+4e7ZxrUtkkX0T2WANp+axXdtQr+A=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsecret ];

  makeFlags = [
    "PREFIX=\${out}"
  ];

  meta = {
    description = "Utility to export messages, attachments and other data from Signal Desktop";
    mainProgram = "sigtop";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fricklerhandwerk ];
  };
})
