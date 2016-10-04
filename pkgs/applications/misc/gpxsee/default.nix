{ stdenv, fetchFromGitHub, qmakeHook }:

stdenv.mkDerivation rec {
  name = "gpxsee-${version}";
  version = "2.17";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "1422kgj972ydasqqm0k02qf3v2py7if2ibri7yjg8awqilacy6by";
  };

  nativeBuildInputs = [ qmakeHook ];
  
  patchPhase = ''
    sed -i '/lang\/gpxsee_cs.qm/d' gpxsee.qrc
  '';

  preFixup = ''
    mkdir -p $out/bin
    cp GPXSee $out/bin
  '';
  
  meta = with stdenv.lib; {
    homepage = http://tumic.wz.cz/gpxsee;
    description = "GPX viewer and analyzer";
    license = licenses.gpl3;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
