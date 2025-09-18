{
  lib,
  stdenv,
  fetchurl,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "gobi_loader";
  version = "0.7";

  src = fetchurl {
    url = "https://www.codon.org.uk/~mjg59/gobi_loader/download/${pname}-${version}.tar.gz";
    sha256 = "0jkmpqkiddpxrzl2s9s3kh64ha48m00nn53f82m1rphw8maw5gbq";
  };

  postPatch = ''
    substituteInPlace 60-gobi.rules --replace "gobi_loader" "${placeholder "out"}/lib/udev/gobi_loader"
    substituteInPlace 60-gobi.rules --replace "/lib/firmware" "/run/current-system/firmware"
  '';

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    description = "Firmware loader for Qualcomm Gobi USB chipsets";
    homepage = "https://www.codon.org.uk/~mjg59/gobi_loader/";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
