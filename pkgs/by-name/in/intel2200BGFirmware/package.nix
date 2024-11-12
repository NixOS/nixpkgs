{ stdenvNoCC
, lib
, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "intel2200BGFirmware";
  version = "3.1";

  src = fetchurl {
    url = "https://src.fedoraproject.org/repo/pkgs/ipw2200-firmware/ipw2200-fw-${version}.tgz/eaba788643c7cc7483dd67ace70f6e99/ipw2200-fw-${version}.tgz";
    hash = "sha256-xoGMEcGMwDDVX/g/ZLK62P7vSF53QvhPlKYdgRpiWL0=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m644 ipw2200-bss.fw     $out/lib/firmware/ipw2200-bss.fw
    install -D -m644 ipw2200-ibss.fw    $out/lib/firmware/ipw2200-ibss.fw
    install -D -m644 ipw2200-sniffer.fw $out/lib/firmware/ipw2200-sniffer.fw
    install -D -m644 LICENSE.ipw2200-fw $out/share/doc/intel2200BGFirmware/LICENSE

    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware for Intel 2200BG cards";
    homepage = "https://ipw2200.sourceforge.net/firmware.php";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = platforms.linux;
  };
}
