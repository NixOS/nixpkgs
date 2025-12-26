{ lib, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule [
      "programs"
      "qt5ct"
      "enable"
    ] "Use qt5.platformTheme = \"qt5ct\" instead.")
  ];
}
