{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "${target}-firmware-${version}";
  version = "${branch}-00042";

  branch = "4.4.1.c1";
  target = "QCA6174";

  src = fetchurl {
    url = "https://github.com/kvalo/ath10k-firmware/raw/952afa4949cb34193040cd4e7441e1aee50ac731/${target}/hw3.0/${branch}/firmware-6.bin_RM.${version}-QCARMSWP-1";
    sha256 = "01vvz3qhqw5l3yilcqgk1spk4y9k4qy7na7a57cbl037r231szdh";
  };

  buildCommand = ''
    install -D $src $out/lib/firmware/ath10k/${target}/hw3.0/firmware-6.bin
  '';

  meta = with stdenv.lib; {
    description = "Updated firmware for the qca6174 wireless chip";
    homepage = "https://github.com/kvalo/ath10k-firmware/tree/master/QCA6174/hw3.0";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ yorickvp ];
    platforms = platforms.linux;
  };
}
