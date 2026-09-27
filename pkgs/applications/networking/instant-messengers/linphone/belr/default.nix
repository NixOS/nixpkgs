{
  bctoolbox,
  lib,
  mkLinphoneDerivation,
}:
mkLinphoneDerivation {
  pname = "belr";

  buildInputs = [
    bctoolbox
  ];

  meta = {
    description = "Belledonne Communications' language recognition library (a SIP parsing library). Part of the Linphone project";
    license = lib.licenses.gpl3Only;
  };
}
