{ stdenv, fetchurl, lib, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "p4";
  version = "2020.2.2057778";

  src = fetchurl {
    url = "https://www.perforce.com/downloads/perforce/r20.2/bin.linux26x86_64/helix-core-server.tgz";
    sha256 = "02fcn8myqkj4xiwxy2xdyp9glc1xqyzblyn564vs1mjy99vm24ym";
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
