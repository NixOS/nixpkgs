{
  lib,
  stdenv,
  fetchFromSourcehut,
  lua,
  luaPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fennel-ls";
  version = "0.1.3";

  src = fetchFromSourcehut {
    owner = "~xerool";
    repo = "fennel-ls";
    rev = finalAttrs.version;
    hash = "sha256-7NifEbOH8TDzon3f6w4I/7uryE1e9M5iYvqEb0hLv5s=";
  };
  buildInputs = [
    lua
    luaPackages.fennel
  ];
  makeFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Language server for intelligent editing of the Fennel Programming Language";
    homepage = "https://git.sr.ht/~xerool/fennel-ls/";
    license = lib.licenses.mit;
    changelog = "https://git.sr.ht/~xerool/fennel-ls/refs/${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      yisraeldov
    ];
    inherit (lua.meta) platforms;
    mainProgram = "fennel-ls";
  };
})
