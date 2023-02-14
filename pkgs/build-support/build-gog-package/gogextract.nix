{ stdenv, lib, python3, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "gogextract";
  version = "6601b32feacecd18bc12f0a4c23a063c3545a095";

  src = fetchFromGitHub {
    owner = "Yepoleb";
    repo = pname;
    rev = version;
    sha256 = "sha256-BTtm3Tn2hFS512w+IcJQfGKSgi2dpYLg1VxNXRODBEI=";
  };

  buildInputs = [ python3 ];

  doBuild = false;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/gogextract.py $out/bin/gogextract
  '';

  meta = with lib; {
    description = "Script for unpacking GOG Linux installers";
    homepage = "https://github.com/Yepoleb/gogextract";
    license = licenses.mit;
    maintainers = with maintainers; [ pmc ];
    platforms = platforms.all;
  };
}
