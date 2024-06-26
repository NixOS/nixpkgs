{
  lib,
  stdenv,
  mkDerivation,
  dpkg,
  fetchurl,
  qtbase,
}:

let
  # To obtain the version you will need to run the following command:
  #
  # dpkg-deb -I ${odafileconverter.src} | grep Version
  version = "21.11.0.0";
  rpath = "$ORIGIN:${
    lib.makeLibraryPath [
      stdenv.cc.cc
      qtbase
    ]
  }";

in
mkDerivation {
  pname = "oda-file-converter";
  inherit version;
  nativeBuildInputs = [ dpkg ];

  src = fetchurl {
    # NB: this URL is not stable (i.e. the underlying file and the corresponding version will change over time)
    url = "https://web.archive.org/web/20201206221727if_/https://download.opendesign.com/guestfiles/Demo/ODAFileConverter_QT5_lnxX64_7.2dll_21.11.deb";
    sha256 = "10027a3ab18efd04ca75aa699ff550eca3bdfe6f7084460d3c00001bffb50070";
  };

  unpackPhase = ''
    dpkg -x $src oda_unpacked
    sourceRoot=$PWD/oda_unpacked
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp -vr $sourceRoot/usr/bin/ODAFileConverter_${version} $out/libexec
    cp -vr $sourceRoot/usr/share $out/share
  '';

  dontWrapQtApps = true;
  fixupPhase = ''
    echo "setting interpreter"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/libexec/ODAFileConverter
    patchelf --set-rpath '${rpath}' $out/libexec/ODAFileConverter
    wrapQtApp $out/libexec/ODAFileConverter
    mv $out/libexec/ODAFileConverter $out/bin

    find $out/libexec -type f -executable | while read file; do
      echo "patching $file"
      patchelf --set-rpath '${rpath}' $file
    done
  '';

  meta = with lib; {
    description = "For converting between different versions of .dwg and .dxf";
    homepage = "https://www.opendesign.com/guestfiles/oda_file_converter";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ nagisa ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ODAFileConverter";
  };
}
