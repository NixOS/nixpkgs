{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libusb1,
  avahi,
  dpkg,
}:

let
  version = "2.27.9";

  sources = {
    x86_64-linux = {
      url = "https://files.digilent.com/Software/Adept2%20Runtime/${version}/digilent.adept.runtime_${version}-amd64.deb";
      hash = "sha256-yKLM8tnqH/oPOkrk7S/2kKBof/gzgrYtrjD6ExmLv1M=";
    };
    i686-linux = {
      url = "https://files.digilent.com/Software/Adept2%20Runtime/${version}/digilent.adept.runtime_${version}-i386.deb";
      hash = "sha256-mEydJgHJve+zLjqjDxsYfcvZzVHmeSVRVsfn+9iA5FQ=";
    };
    aarch64-linux = {
      url = "https://files.digilent.com/Software/Adept2%20Runtime/${version}/digilent.adept.runtime_${version}-arm64.deb";
      hash = "sha256-JkeYRYyOH5NSHndWUWO4Ig7weWnbmhnEa9QPHYnPKek=";
    };
    armv7l-linux = {
      url = "https://files.digilent.com/Software/Adept2%20Runtime/${version}/digilent.adept.runtime_${version}-armhf.deb";
      hash = "sha256-zKuK5nMcWmbH/CPTA1pvL6N0wzaOIm4/BI90sPEAby8=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {

  pname = "adept2-runtime";
  inherit version;

  src = fetchurl {
    url = source.url;
    hash = source.hash;
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    libusb1
    avahi
  ];

  unpackCmd = "dpkg -x $curSrc out";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{etc,share} $out/etc/udev/rules.d

    cp -a usr/lib*/digilent/adept $out/lib
    cp -a usr/sbin $out/
    cp -a usr/share/{doc,digilent} $out/share/

    cat > $out/etc/digilent-adept.conf <<EOF
    DigilentPath=$out/share/digilent
    DigilentDataPath=$out/share/digilent/adept/data
    EOF

    cat > $out/etc/udev/rules.d/52-digilent-usb.rules <<EOF
    ACTION=="add", ATTR{idVendor}=="1443", GROUP+="plugdev", TAG+="uaccess"
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", GROUP+="plugdev", TAG+="uaccess", RUN+="$out/sbin/dftdrvdtch %s{busnum} %s{devnum}"
    EOF

    runHook postInstall
  '';

  dontAutoPatchelf = true;

  postFixup = ''
    autoPatchelf "$out"

    for lib in $(find "$out/lib" -type f); do
      lib_rpath="$(patchelf --print-rpath "$lib")"
      echo "Adding self to RPATH of library $lib"
      patchelf --set-rpath "$out/lib:$lib_rpath" "$lib"
    done;
  '';

  meta = {
    description = "Digilent Adept Runtime";
    homepage = "https://reference.digilentinc.com/reference/software/adept/start";
    downloadPage = "https://mautic.digilentinc.com/adept-runtime-download";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      liff
      phodina
    ];
  };
})
