{ lib
, stdenv
, fetchFromSourcehut
, lua
, luaPackages
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fennel-ls";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~xerool";
    repo = "fennel-ls";
    rev = finalAttrs.version;
    hash = "sha256-RW3WFJGwascD4YnnrAm/2LFnVigzgtfzVubLMDW9J5s=";
  };
  buildInputs = [ lua luaPackages.fennel ];
  makeFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A language server for intelligent editing of the Fennel Programming Language";
    homepage = "https://git.sr.ht/~xerool/fennel-ls/";
    license = licenses.mit;
    maintainers = with maintainers; [ yisraeldov ];
    platforms = lua.meta.platforms;
    mainProgram = "fennel-ls";
  };
})
