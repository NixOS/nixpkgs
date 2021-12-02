{ stdenv, fetchurl, lib, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "p4";
  version = "2020.1.2179737";

  src = fetchurl {
    url = "https://www.perforce.com/downloads/perforce/r21.1/bin.linux26x86/helix-core-server.tgz";
    sha256 = "1fr4nidbqcxhpkx41j6c2garx4vxywqcr7a8jm37nxy7ihly00vd";
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
