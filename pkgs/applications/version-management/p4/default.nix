{ stdenv, fetchurl, lib, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "p4";
  version = "2021.1.2126753";

  src = fetchurl {
    url = "https://www.perforce.com/downloads/perforce/r21.1/bin.linux26x86_64/helix-core-server.tgz";
    sha256 = "064cdx2r6aix0mawm1jklbfhwmzkj1146fkqjadz9sv79zj3g35p";
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
