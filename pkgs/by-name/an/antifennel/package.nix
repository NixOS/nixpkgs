{
  lib,
  stdenv,
  luajit,
  luapkgs ? luajit.pkgs,
  pandoc,
  fennel-ls,
  fetchFromSourcehut,
  ...
}:
stdenv.mkDerivation rec {
  pname = "antifennel";
  version = "0.3.1";
  src = fetchFromSourcehut {
    owner = "~technomancy";
    repo = pname;
    rev = "a135f016414517ecb624bad26b39ed56d256beaa";
    hash = "sha256-XynKKDyykyPM4z2ZLp9Oy8KFlEZG2iHXKMkajaS/DaE=";
  };
  patches = [ ./shebang.patch ];
  nativeBuildInputs = [ pandoc ];
  LUA = luapkgs.lua.interpreter;
  installPhase = ''
    make install PREFIX=$out
  '';
  checkInputs = [
    luapkgs.luacheck
    fennel-ls
  ];
  meta = {
    mainProgram = pname;
    description = "fennel decompiler which produces fennel code from lua code";
    homepage = "https://git.sr.ht/~technomancy/antifennel";
    changelog = "https://git.sr.ht/~technomancy/antifennel/tree/${src.rev}/item/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ birdee ];
  };
}
