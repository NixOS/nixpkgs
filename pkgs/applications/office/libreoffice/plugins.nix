{ stdenv, fetchFromGitHub, ruby.devEnv, zip }:

stdenv.mkDerivation rec {
  pname = "libreoffice-impress-templates";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "dohliam";
    repo = "libreoffice-impress-templates";
    rev = "v${version}";
    sha256 = "1kgxzm70rn071w6w7jjbasyvpf6jxsldl6c1gszdp1fzhv15qj0p";
  };

  nativeBuildInputs = [ ruby, zip ];

  patchPhase = ''
    patchShebangs scripts/repack_otp.rb
  ''

  installPhase = ''
    EXCLUDE_DEFAULTS=/beehive/|/blue-curve/|/classy-red/|/clean-inspiration/|/dna/|/focus/|/impress/|/lights/|/nature-illustration/|/metropolis/|/pencil/|/piano/|/portfolio/|/progress/
    TEMPLATES=($(ls -d1 */*/ | grep -Ev "$EXCLUDE_DEFAULTS"))
    ./scripts/repack_otp.rb ${TEMPLATES[@]}
    mkdir -p $out/share/template/common/presnt
    install -vDm755 */*.otp $out/share/template/common/presnt/
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/dohliam/libreoffice-impress-templates";
    description = "Templates for LibreOffice Impress";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ louisdk1 ];
  };

};

