{ lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "numworks-udev-rules";
  version = "unstable-2020-08-31";

  udevRules = ./50-numworks-calculator.rules;
  dontUnpack = true;

  installPhase = ''
    install -Dm 644 "${udevRules}" "$out/lib/udev/rules.d/50-numworks-calculator.rules"
  '';

  meta = with lib; {
    description = "Udev rules for Numworks calculators";
    homepage = "https://numworks.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
