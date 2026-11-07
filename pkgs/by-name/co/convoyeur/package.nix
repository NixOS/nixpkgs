{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "convoyeur";
  version = "0.1.2";

  src = fetchFromCodeberg {
    owner = "classabbyamp";
    repo = "convoyeur";
    tag = "v${version}";
    hash = "sha256-l4QAZJX9ht10cwqk/yckmrfdu46vYQlOeT1UtsT+SRY=";
  };

  cargoHash = "sha256-KvPwyyEK3qI77KDhrqMwcFH4Vq0PF5pRMkFsZggtWS4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IRCv3 FILEHOST extension adapter to external file upload services";
    homepage = "https://codeberg.org/classabbyamp/convoyeur";
    mainProgram = "convoyeur";
    license = lib.licenses.liliq-p-11;
    maintainers = with lib.maintainers; [ lenny ];
  };
}
