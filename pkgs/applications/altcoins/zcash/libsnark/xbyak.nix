{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "xbyak-unstable-${version}";
  version = "2016-05-03";

  src = fetchFromGitHub {
    owner = "herumi";
    repo  = "xbyak";
    rev = "b6133a02dd6b7116bea31d0e6b7142bf97f071aa";
    sha256 = "1rc2nx8kj2lj13whxb9chhh79f4hmjjj4j1hpqsd0lbdb60jikrn";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include
    cp -r xbyak $out/include
  '';

  meta = with stdenv.lib; {
    description = "JIT assembler for x86, x64";
    homepage = https://github.com/herumi/xbyak;
    maintainers = with maintainers; [ rht ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
