{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xbyak";
  version = "2016-05-03-git";

  src = fetchFromGitHub {
    owner = "herumi";
    repo  = name;
    rev = "b6133a02dd6b7116bea31d0e6b7142bf97f071aa";
    sha256 = "1rc2nx8kj2lj13whxb9chhh79f4hmjjj4j1hpqsd0lbdb60jikrn";
  };

  phases = ["unpackPhase" "installPhase"];

  installPhase = ''
    mkdir -p $out/include
    cp -r xbyak $out/include
  '';

  meta = with stdenv.lib; {
    description = "JIT assembler for x86, x64";
    homepage = "https://github.com/herumi/xbyak";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
