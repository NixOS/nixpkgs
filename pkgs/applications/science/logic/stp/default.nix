{stdenv, cmake, boost, bison, flex, fetchgit, perl, zlib}: 
stdenv.mkDerivation rec {
  version = "2014.01.07";
  name = "stp-${version}";
  src = fetchgit {
    url    = "git://github.com/stp/stp";
    rev    = "3aa11620a823d617fc033d26aedae91853d18635";
    sha256 = "832520787f57f63cf47364d080f30ad10d6d6e00f166790c19b125be3d6dd45c";
  };
  buildInputs = [ cmake boost bison flex perl zlib ];
  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];
  patchPhase = ''
      sed -e 's,^export(PACKAGE.*,,' -i CMakeLists.txt
      patch -p1 < ${./fixbuild.diff}
      patch -p1 < ${./fixrefs.diff}
  '';
  meta = {
    description = ''Simple Theorem Prover'';
    maintainers = with stdenv.lib.maintainers; [mornfall];
    platforms = with stdenv.lib.platforms; linux;
    license = with stdenv.lib.licenses; mit;
  };
}
