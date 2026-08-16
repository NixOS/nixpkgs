{
  fetchFromSourcehut,
  hareHook,
  lib,
  scdoc,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "himitsu";
  version = "0.10";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "himitsu";
    rev = finalAttrs.version;
    hash = "sha256-mG70yAZ0iq4KH6a99jM4MM5FSlx4BE7cvfdk+N1mo5w=";
  };

  nativeBuildInputs = [
    hareHook
    scdoc
  ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://himitsustore.org/";
    description = "Secret storage manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ auchter ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
