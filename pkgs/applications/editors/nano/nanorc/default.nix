{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "nanorc-${version}";
  version = "2018-09-05";

  src = fetchFromGitHub {
    owner = "scopatz";
    repo = "nanorc";
    rev = "1e589cb729d24fba470228d429e6dde07973d597";
    sha256 = "136yxr38lzrfv8bar0c6c56rh54q9s94zpwa19f425crh44drppl";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share

    install *.nanorc $out/share/
  '';

  meta = {
    description = "Improved Nano Syntax Highlighting Files";
    homepage = https://github.com/scopatz/nanorc;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ nequissimus ];
    platforms = stdenv.lib.platforms.all;
  };
}
