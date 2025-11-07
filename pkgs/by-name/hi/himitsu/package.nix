{
  fetchFromSourcehut,
  hareHook,
  lib,
  scdoc,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "himitsu";
  version = "0.8";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "himitsu";
    rev = finalAttrs.version;
    hash = "sha256-+GQgRPJut+3zvzSyTGujTbbwJNNgHtFxAoEEwU0lbfU=";
  };

  nativeBuildInputs = [
    hareHook
    scdoc
  ];

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://himitsustore.org/";
    description = "Secret storage manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ auchter ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
})
