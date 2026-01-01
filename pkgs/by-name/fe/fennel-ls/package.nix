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
<<<<<<< HEAD
  version = "0.2.3";
=======
  version = "0.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromSourcehut {
    owner = "~xerool";
    repo = "fennel-ls";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-BU0SkdBjq8kicvACIo3N2gf1UvTmzA3FKSt39Lxp3rs=";
=======
    hash = "sha256-N1530u8Kq7ljdEdTFk0CJJyMLMVX5huQWXjyoMBJN5E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
