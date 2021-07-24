{ stdenv, fetchurl, lib, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "p4";
  version = "2020.1.2156517";

  src = fetchurl {
    url = "https://cdist2.perforce.com/perforce/r20.1/bin.linux26x86_64/helix-core-server.tgz";
    sha256 = "NmXWllJk4rK1Z8rxngSOGONo2zoRMLAsUnPialbRP/I=";
  };

  sourceRoot = ".";

  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    mkdir -p $out/bin
    cp p4 p4broker p4d p4p $out/bin
  '';

  meta = {
    description = "Perforce Command-Line Client";
    homepage = "https://www.perforce.com";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ corngood ];
  };
}
