{
  lib,
  stdenv,
  fetchFromSourcehut,
  lua,
  luaPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fennel-ls";
  version = "0.1.2";

  src = fetchFromSourcehut {
    owner = "~xerool";
    repo = "fennel-ls";
    rev = finalAttrs.version;
    hash = "sha256-8TDJ03x9dkfievbovzMN3JRfIKba3CfzbcRAZOuPbKs=";
  };
  buildInputs = [
    lua
    luaPackages.fennel
  ];
  makeFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Language server for intelligent editing of the Fennel Programming Language";
    homepage = "https://git.sr.ht/~xerool/fennel-ls/";
    license = licenses.mit;
    changelog = "https://git.sr.ht/~xerool/fennel-ls/refs/${version}";
    maintainers = with maintainers; [
      luftmensch-luftmensch
      yisraeldov
    ];
    inherit (lua.meta) platforms;
    mainProgram = "fennel-ls";
  };
})
