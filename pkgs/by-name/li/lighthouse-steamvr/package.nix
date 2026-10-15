{
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "Lighthouse";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = "Lighthouse";
    rev = finalAttrs.version;
    hash = "sha256-TCl3X1AmJx53Dr0A9DYbk0HkaDjW0dgD4Jssg7W4vFk=";
  };

  cargoHash = "sha256-1xl8X0JQbeGlM5wMdTpFQsZ2lLPndOZSU57zVc6rhe8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];
  buildFeatures = [ "cli" ];

  meta = {
    description = "VR Lighthouse power state management";
    homepage = "https://github.com/ShayBox/Lighthouse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "lighthouse";
  };
})
