{ stdenv
, lib
, pkg-config
, makeWrapper
, texinfo
, fetchurl
, autoreconfHook
, guile
, flex
, gtk2
, glib
, gtkextra
, gettext
, gawk
, shared-mime-info
, groff
, libstroke
}:

stdenv.mkDerivation rec {
  pname = "lepton-eda";
  version = "1.9.17-20211219";

  src = fetchurl {
    url = "https://github.com/lepton-eda/lepton-eda/releases/download/${version}/lepton-eda-${builtins.head (lib.splitString "-" version)}.tar.gz";
    sha256 = "sha256-lOneKeJUcw6jOX/3iv9BDWOJ3xip/vGhzxHHNAbtsS8=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper texinfo autoreconfHook ];

  propagatedBuildInputs = [ guile flex gtk2 glib gtkextra gettext gawk shared-mime-info groff libstroke ];

  configureFlags = [
    "--disable-update-xdg-database"
  ];

  CFLAGS = [
    "-DSCM_DEBUG_TYPING_STRICTNESS=2"
  ];

  postInstall = ''
    libs="${lib.makeLibraryPath propagatedBuildInputs}"
    for program in $out/bin/*; do
      wrapProgram "$program" \
        --prefix LD_LIBRARY_PATH : "$libs" \
        --prefix LTDL_LIBRARY_PATH : "$out/lib"
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/lepton-eda";
    description = "Lepton Electronic Design Automation";
    longDescription = ''
      Lepton EDA is a suite of free software tools for designing electronics.
      It provides schematic capture, netlisting into over 30 netlist formats, and many other features.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tesq0 ];
  };
}
