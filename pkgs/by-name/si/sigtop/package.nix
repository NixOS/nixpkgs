{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:

buildGoModule (finalAttrs: {
  pname = "sigtop";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZI4GuXWeLuEIKEQtsv6nugsfIc/Dlj2JYoVVmAr2O28=";
  };

  vendorHash = "sha256-NyZTLut10DBNlBYIXjRB9zL98ZZ/A6hu0ypsu3GjHq8=";

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
