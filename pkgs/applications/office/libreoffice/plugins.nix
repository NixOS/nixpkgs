{ stdenv, fetchFromGitHub, ruby, zip }:

stdenv.mkDerivation rec {
  pname = "libreoffice-impress-templates";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "dohliam";
    repo = "libreoffice-impress-templates";
    rev = "v${version}";
    sha256 = "0vird1fapcvimw7fa7dj08bqsmjzp5r2zczhnk4n5g9xc724azvk";
  };

  nativeBuildInputs = [ ruby zip ];

  patchPhase = ''
    patchShebangs scripts/repack_otp.rb
  '';

  installPhase = ''
#    EXCLUDE_DEFAULTS=/beehive/|/blue-curve/|/classy-red/|/clean-inspiration/|/dna/|/focus/|/impress/|/lights/|/nature-illustration/|/metropolis/|/pencil/|/piano/|/portfolio/|/progress/
#    TEMPLATES=(''$(ls -d1 */*/ | grep -Ev ''$EXCLUDE_DEFAULTS))
#    for i in ''$(find -mindepth 2 -maxdepth 2 ! -name material-simple -type d;find user-contrib -mindepth 2 -maxdepth 2 -type d); do
#      zip -r ''$(basename $i).otp $i
#    done
#    find -mindepth 2 -maxdepth 2 ! -name material-simple -type d -exec echo zip -r ''$(echo {}|basename).otp {} \;
#    find user-contrib -mindepth 2 -maxdepth 2 -type d -exec echo zip -r ''$(echo {}.otp {} \;
    find -mindepth 2 -maxdepth 2 ! -name material-simple -type d -exec VAR={} echo $VAR \;
    mkdir -p $out/share/template/common/presnt/
    install -vDm755 *.otp $out/share/template/common/presnt/    
 '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/dohliam/libreoffice-impress-templates";
    description = "Templates for LibreOffice Impress";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ louisdk1 ];
  };

}

