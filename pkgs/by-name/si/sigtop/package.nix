{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:

buildGoModule (finalAttrs: {
  pname = "sigtop";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-NJl30LCIiPWTqbpTPW6wa9OsCl19bc//QZsMJIUImR4=";
  };

  vendorHash = "sha256-6pNBYziJvJ1MMjzcbIjPFAUTW6ZrCNmtYzzAS/ANtEw=";

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
