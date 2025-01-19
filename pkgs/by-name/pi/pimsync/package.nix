{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  pkg-config,
  sqlite,
  scdoc,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "pimsync";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "pimsync";
    rev = "v${version}";
    hash = "sha256-upOCrpbveSSFrhdHDkTOmja4MLmsgtuoDHMsgXyulWI=";
  };

  cargoHash = "sha256-QRgyHzIjdI8+OzvM+3sfuxTNMVCdGxrMvQpCnot9iUM=";

  nativeBuildInputs = [
    pkg-config
    scdoc
    makeWrapper
  ];

  buildInputs = [
    sqlite
  ];

  makeFlags = [
    "build"
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Synchronise calendars and contacts";
    homepage = "https://git.sr.ht/~whynothugo/pimsync";
    license = lib.licenses.eupl12;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.qxrein ];
    mainProgram = "pimsync";
  };
}
