{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "rdiary";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lonyelon";
    repo = "rdiary";
    rev = "v0.1.0";
    hash = "sha256-N6wyZdo3CL57DzzRx3Rc4iYwlUyrTYPJOaBLVKzSwUw=";
  };

  cargoHash = "sha256-HfXIq1auLdIhspQNnb8V2/AgBmpaaC15CcqTbPDDaUA=";

  meta = {
    description = "Very simple diary writer";
    homepage = "https://github.com/lonyelon/rdiary";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lonyelon ];
  };
}
