{ stdenv, fetchFromGitHub, qmakeHook }:

stdenv.mkDerivation rec {
  name = "gpxsee-${version}";
  version = "2.16";

  src = fetchFromGitHub {
    owner = "tumic0";
    repo = "GPXSee";
    rev = version;
    sha256 = "0xqmjh071my9klxlk5afx8r673zlknq84n7ain6mz9i8n9m1gviv";
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
