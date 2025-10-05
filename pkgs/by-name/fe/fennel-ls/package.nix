{
  lib,
  stdenv,
  fetchFromSourcehut,
  lua,
  luaPackages,
  pandoc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fennel-ls";
  version = "0.2.1";

  src = fetchFromSourcehut {
    owner = "~xerool";
    repo = "fennel-ls";
    rev = finalAttrs.version;
    hash = "sha256-6ZbGRTBBRktudGVBZ+UMn8l0+wKa8f5dg7UOwLhOT7E=";
  };
  buildInputs = [
    lua
    luaPackages.fennel
  ];
  nativeBuildInputs = [ pandoc ];
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
