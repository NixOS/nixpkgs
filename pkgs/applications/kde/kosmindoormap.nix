{ mkDerivation
, lib
, bison
, extra-cmake-modules
, flex
, ki18n
, kopeninghours
, kpublictransport
}:

mkDerivation {
  pname = "kosmindoormap";
  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    bison
    extra-cmake-modules
    flex
  ];

  buildInputs = [
    ki18n
    kopeninghours
    kpublictransport
  ];

  meta = {
    license = with lib.licenses; [ bsd2 bsd3 cc0 lgpl2Plus lgpl3Plus mit odbl ];
  };
}
