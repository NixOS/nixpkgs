{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:

buildGoModule (finalAttrs: {
  pname = "sigtop";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-EvdO7fGnNdu1/f61c4k2dpeMUqKaq9xKGgevAQ+f3q0=";
  };

  vendorHash = "sha256-EAMnuDm3Lmw2i4sumgCTE58JCtMq9QeT6pjtmC/PKMA=";

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
