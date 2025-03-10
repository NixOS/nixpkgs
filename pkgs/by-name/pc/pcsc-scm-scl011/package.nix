{
  lib,
  stdenv,
  fetchurl,
  unzip,
  libusb-compat-0_1,
}:

let
  arch =
    if stdenv.hostPlatform.system == "i686-linux" then
      "32"
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      "64"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  pname = "pcsc-scm-scl";
  version = "2.09";

  src = fetchurl {
    url = "http://files.identiv.com/products/smart-card-readers/contactless/scl010-011/Linux_Driver_Ver${version}.zip";
    sha256 = "0ik26sxgqgsqplksl87z61vwmx51k7plaqmrkdid7xidgfhfxr42";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
    tar xf "Linux Driver Ver${version}/sclgeneric_${version}_linux_${arch}bit.tar.gz"
    export sourceRoot=$(readlink -e sclgeneric_${version}_linux_${arch}bit)
  '';

  # Add support for SCL011 nPA (subsidized model for German eID)
  patches = [ ./eid.patch ];

  installPhase = ''
    mkdir -p $out/pcsc/drivers
    cp -r proprietary/*.bundle $out/pcsc/drivers
  '';

  libPath = lib.makeLibraryPath [ libusb-compat-0_1 ];

  fixupPhase = ''
    patchelf --set-rpath $libPath \
      $out/pcsc/drivers/SCLGENERIC.bundle/Contents/Linux/libSCLGENERIC.so.${version};
  '';

  meta = with lib; {
    description = "SCM Microsystems SCL011 chipcard reader user space driver";
    homepage = "https://www.scm-pc-card.de/index.php?lang=en&page=product&function=show_product&product_id=630";
    downloadPage = "https://support.identiv.com/scl010-scl011/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ sephalon ];
    platforms = platforms.linux;
  };
}
