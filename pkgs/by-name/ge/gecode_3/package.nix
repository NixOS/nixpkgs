{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "gecode";
  version = "3.7.3";

  src = fetchurl {
    url = "http://www.gecode.org/download/${pname}-${version}.tar.gz";
    sha256 = "0k45jas6p3cyldgyir1314ja3174sayn2h2ly3z9b4dl3368pk77";
  };

  patches = [
    # https://github.com/Gecode/gecode/pull/74
    (fetchpatch {
      name = "fix-const-weights-clang.patch";
      url = "https://github.com/Gecode/gecode/commit/c810c96b1ce5d3692e93439f76c4fa7d3daf9fbb.patch";
      sha256 = "0270msm22q5g5sqbdh8kmrihlxnnxqrxszk9a49hdxd72736p4fc";
    })
  ];

  postPatch = ''
    substituteInPlace gecode/flatzinc/lexer.yy.cpp \
      --replace "register " ""
  '';

  nativeBuildInputs = [ perl ];

  preConfigure = "patchShebangs configure";

  env.CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++14";

  meta = {
    license = lib.licenses.mit;
    homepage = "https://www.gecode.org";
    description = "Toolkit for developing constraint-based systems";
    platforms = lib.platforms.all;
    hasNoMaintainersButDependents = true;
  };
}
