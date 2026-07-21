{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "carl";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "b1rger";
    repo = "carl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ikD4T3zP/IJ+8Wxn8aohJTKbcy+QKAUoX/kkVAUVoNk=";
  };

  doCheck = false;

  cargoHash = "sha256-b2BilwYCNTT1B3Cuia8N6ay6HRxf0Mkrkdu5qzksxoQ=";

  meta = {
    description = "cal(1) with more features and written in rust";
    longDescription = ''
      Carl is a calendar for the commandline. It tries to mimic the various cal(1)
      implementations out there, but also adds enhanced features like colors and ical
      support
    '';
    homepage = "https://github.com/b1rger/carl";
    changelog = "https://github.com/b1rger/carl/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "carl";
  };
})
