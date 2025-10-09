{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation rec {
  pname = "shortcat";
  version = "0.12.2";

  src = fetchurl {
    url = "https://files.shortcat.app/releases/v${version}/Shortcat.zip";
    sha256 = "sha256-jmp9mBMYID0Zcu/o6ICYPS8QGHhSwcLz072jG3zR2mM=";
  };

  sourceRoot = "Shortcat.app";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/Applications/Shortcat.app
    cp -R . $out/Applications/Shortcat.app
  '';

  meta = with lib; {
    description = "Manipulate macOS masterfully, minus the mouse";
    homepage = "https://shortcat.app/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.darwin;
    maintainers = with lib.maintainers; [ t-monaghan ];
    license = licenses.unfreeRedistributable;
  };
}
