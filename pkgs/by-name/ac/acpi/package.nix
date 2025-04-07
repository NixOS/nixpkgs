{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "acpi";
  version = "1.8";

  src = fetchurl {
    url = "mirror://sourceforge/acpiclient/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-5kxuALU815dCfqMqFgUTQlsD7U8HdzP3Hx8J/zQPIws=";
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
