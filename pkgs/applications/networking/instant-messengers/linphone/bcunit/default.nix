{
  mkLinphoneDerivation,
  lib,
}:
mkLinphoneDerivation {
  pname = "bcunit";

  meta = {
    description = "Fork of the defunct project CUnit, a unit testing framework";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      jluttine
      naxdy
      raskin
    ];
  };
}
