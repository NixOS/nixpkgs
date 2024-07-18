{ stdenv, lib, fetchurl }:

let
  rev = "8a3ca204ec3751e93af2d79b9fbdc2fb9eeb2adc";
in
stdenv.mkDerivation rec {
  pname = "dut";
  # Not officially versioned but using the date of the commit
  version = "2024-07-14";

  src = fetchurl {
    url = "https://codeberg.org/201984/dut/archive/${rev}.tar.gz";
    sha256 = "sha256-GvuVvN7V/U4K3jfci1z8wceZUsWt9OdIN9lWslLfLvM=";
  };

  installFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  meta = with lib; {
    description = "A disk usage calculator for Linux";
    homepage = "https://codeberg.org/201984/dut";
    license = licenses.gpl3;
    maintainers = with maintainers; [ errnoh ];
    mainProgram = "dut";
  };
}

