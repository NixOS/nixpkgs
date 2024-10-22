{ lib, fetchurl, stdenv, unzip, fpc }:

stdenv.mkDerivation rec {
  pname = "dolbybcsoftwaredecode";
  version = "april-2018";

  src = fetchurl {
    url = "mirror://sourceforge/dolbybcsoftwaredecode/April-2018/SourceCode.zip";
    sha256 = "sha256-uLcsRIpwmJlstlGV8I4+/30+D9GDpUt7DOIP/GkXWp4=";
  };

  nativeBuildInputs = [ unzip fpc ];
  buildPhase = ''
    fpc DolbyBi64.PP
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp DolbyBi64 $out/bin/
  '';

  meta = with lib; {
    description = "Dolby B & C software decoder";
    homepage = "https://sourceforge.net/projects/dolbybcsoftwaredecode/";
    maintainers = with maintainers; [ lorenz ];

    # Project is has source code available, but has no explicit license.
    # I asked upstream to assign a license, so maybe this can be free
    # in the future, but for now let's play it safe and make it unfree.
    license = lib.licenses.unfree;
    mainProgram = "DolbyBi64";
  };
}
