{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "acpi";
  version = "1.7";

  src = fetchurl {
    url = "mirror://sourceforge/acpiclient/${version}/${pname}-${version}.tar.gz";
    sha256 = "01ahldvf0gc29dmbd5zi4rrnrw2i1ajnf30sx2vyaski3jv099fp";
  };

  meta = with lib; {
    description = "Show battery status and other ACPI information";
    mainProgram = "acpi";
    longDescription = ''
      Linux ACPI client is a small command-line
      program that attempts to replicate the functionality of
      the "old" `apm' command on ACPI systems.  It includes
      battery and thermal information.
    '';
    homepage = "https://sourceforge.net/projects/acpiclient/";
    license = lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
