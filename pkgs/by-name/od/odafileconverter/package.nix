{
  lib,
  stdenv,
  dpkg,
  fetchurl,
  qt6,
  libGL,
}:

let
  rpath = "$ORIGIN:${
    lib.makeLibraryPath [
      stdenv.cc.cc
      qt6.qtbase
      libGL
    ]
  }";

in
stdenv.mkDerivation rec {
  pname = "oda-file-converter";
  # To obtain the version you will need to run the following command:
  #
  # dpkg-deb -I ${odafileconverter.src} | grep Version
  version = "25.11.0.0";

  src = fetchurl {
    # NB: this URL is not stable (i.e. the underlying file and the corresponding version will change over time)
    url = "https://web.archive.org/web/20241212154957/https://www.opendesign.com/guestfiles/get?filename=ODAFileConverter_QT6_lnxX64_8.3dll_25.11.deb";
    hash = "sha256-lykCOT9gmXZ3vGmak8mvrIMBEmGMJ/plmE3vkk9EjYo=";
  };

  buildInputs = [
    qt6.qtbase
  ];
  nativeBuildInputs = [
    dpkg
    qt6.wrapQtAppsHook
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp -vr usr/bin/ODAFileConverter_${version} $out/libexec
    cp -vr usr/share $out/share
  '';

  dontWrapQtApps = true;
  fixupPhase = ''
    echo "setting interpreter"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/libexec/ODAFileConverter
    patchelf --set-rpath '${rpath}' $out/libexec/ODAFileConverter
    wrapQtApp $out/libexec/ODAFileConverter
    mv $out/libexec/ODAFileConverter $out/bin

    find $out/libexec -not -path "*/doc/*" -not -path "*/translations/*" -type f -executable | while read file; do
      echo "patching $file"
      patchelf --set-rpath '${rpath}' $file
    done
  '';

  meta = with lib; {
    description = "For converting between different versions of .dwg and .dxf";
    homepage = "https://www.opendesign.com/guestfiles/oda_file_converter";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      nagisa
      konradmalik
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "ODAFileConverter";
  };
}
