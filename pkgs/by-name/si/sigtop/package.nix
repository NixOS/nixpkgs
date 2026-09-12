{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:

buildGoModule (finalAttrs: {
  pname = "sigtop";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3EDKhV6aYCZbC2onlErzJfdFifutqOq21SzQRKSypeA=";
  };

  vendorHash = "sha256-5toVhaGmm9OTqtrMe0m0h/KBxpLwoZUUgfvv/av2/io=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsecret ];

  makeFlags = [
    "PREFIX=\${out}"
  ];

  meta = {
    description = "Utility to export messages, attachments and other data from Signal Desktop";
    homepage = "https://github.com/tbvdm/sigtop";
    mainProgram = "sigtop";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fricklerhandwerk ];
  };
})
