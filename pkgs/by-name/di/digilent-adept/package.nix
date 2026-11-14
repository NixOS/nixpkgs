{
  lib,
  stdenv,

  autoPatchelfHook,
  fetchurl,

  avahi,
  libusb1,
  openssl,
}:
let
  version = "2.30.1";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://files.digilent.com/Software/Adept2%20Runtime/${version}/digilent.adept.runtime_${version}_amd64.deb";
      hash = "sha256-5eUdJkDC/zTvO0NvO983g4EgsVFg1z37q4LpB3O2s3I=";
    };

    aarch64-linux = fetchurl {
      url = "https://files.digilent.com/Software/Adept2%20Runtime/${version}/digilent.adept.runtime_${version}_arm64.deb";
      hash = "sha256-jNRg4/vK+4ttctztRO3Mm6aOpy/+a7pJ4N+q1xugc5I=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "digilent-adept";
  inherit version;
  __structuredAttrs = true;

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    avahi
    libusb1
    openssl
  ];

  unpackPhase = ''
    runHook preUnpack

    ar x "$src"
    tar -xf data.tar.gz

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"/{bin,etc,lib/udev/rules.d,share}

    cp usr/lib/udev/dftdrvdtch "$out/bin/"
    cp -r usr/lib/digilent/adept/. "$out/lib/"
    cp -r usr/share/. "$out/share/"

    cat > "$out/etc/digilent-adept.conf" << EOF
    DigilentPath=$out/share/digilent
    DigilentDataPath=$out/share/digilent/adept/data
    EOF

    cat > "$out/lib/udev/rules.d/52-digilent-usb.rules" << EOF
    ATTR{idVendor}=="1443", MODE:="666"
    ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666", RUN+="$out/bin/dftdrvdtch %s{busnum} %s{devnum}"
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Communicate with Digilent system boards";
    downloadPage = "https://digilent.com/shop/software/digilent-adept/download";
    homepage = "https://digilent.com/reference/software/adept/start";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ iJustLeyxo ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
