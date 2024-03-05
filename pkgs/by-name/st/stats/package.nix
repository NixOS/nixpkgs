{ lib
, stdenvNoCC
, fetchurl
, darwin
}:

darwin.installBinaryPackage rec {
  pname = "stats";
  version = "2.10.3";

  src = fetchurl {
    url = "https://github.com/exelban/stats/releases/download/v${version}/Stats.dmg";
    hash = "sha256-PSRK9YihiIHKHade3XE/OnAleBhmu71CNFyzJ/Upx/A=";
  };
  sourceRoot = "Stats";

  meta = with lib; {
    description = "macOS system monitor in your menu bar";
    homepage = "https://github.com/exelban/stats";
    license = licenses.mit;
    maintainers = with maintainers; [ emilytrau Enzime ];
  };
}
