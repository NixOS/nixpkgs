{ lib, stdenv, fetchurl, p7zip }:

let
  src_x86 = fetchurl {
    url = "http://apt.univention.de/download/addons/gplpv-drivers/gplpv_Vista2008x32_signed_0.11.0.373.msi";
    sha256 = "04r11xw8ikjmcdhrsk878c86g0d0pvras5arsas3zs6dhgjykqap";
  };

  src_amd64 = fetchurl {
    url = "http://apt.univention.de/download/addons/gplpv-drivers/gplpv_Vista2008x64_signed_0.11.0.373.msi";
    sha256 = "00k628mg9b039p8lmg2l9n81dr15svy70p3m6xmq6f0frmci38ph";
  };
in

stdenv.mkDerivation {
  pname = "gplpv";
  version = "0.11.0.373";

  dontUnpack = true;

  buildPhase = ''
    mkdir -p x86
    (cd x86; ${p7zip}/bin/7z e ${src_x86})
    mkdir -p amd64
    (cd amd64; ${p7zip}/bin/7z e ${src_amd64})
  '';

  installPhase = ''
    mkdir -p $out/x86 $out/amd64
    cp x86/* $out/x86/.
    cp amd64/* $out/amd64/.
  '';

  meta = with lib; {
    description = ''
      A collection of open source Window PV drivers that allow
      Windows to be para-virtualized.
      The drivers are signed by Univention with a Software Publishers
      Certificate obtained from the VeriSign CA.
    '';
    homepage = "http://wiki.univention.de/index.php?title=Installing-signed-GPLPV-drivers";
    maintainers = [ maintainers.tstrobel ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
