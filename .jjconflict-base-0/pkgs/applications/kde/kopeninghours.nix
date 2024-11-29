{ mkDerivation
, lib
, bison
, extra-cmake-modules
, flex
, kholidays
, ki18n
}:

mkDerivation {
  pname = "kopeninghours";
  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    bison
    extra-cmake-modules
    flex
  ];

  buildInputs = [
    kholidays
    ki18n
  ];

  meta = {
    license = with lib.licenses; [ bsd3 cc0 lgpl2Plus ];
  };
}
