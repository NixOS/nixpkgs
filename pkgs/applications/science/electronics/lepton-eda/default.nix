{ stdenv,
lib,
pkgconfig,
makeWrapper,
texinfo,
fetchurl,
autoreconfHook,
guile,
flex,
gtk2,
glib,
gtkextra,
gettext,
gawk,
shared-mime-info,
groff,
libstroke
}:

let
  version = "1.9.13-20201211";
  shortVer = builtins.head (lib.splitString "-" version);
in
stdenv.mkDerivation rec {

  pname = "lepton-eda";

  inherit version;

  src = fetchurl {
    url = "https://github.com/lepton-eda/lepton-eda/releases/download/${version}/lepton-eda-${shortVer}.tar.gz";
    sha256 = "17z1r9mdc8b4q6k8x7xv8ixkbkzhrlnw4l53wn64srd72labf5zl";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper texinfo autoreconfHook ];

  propagatedBuildInputs = [ guile flex gtk2 glib gtkextra gettext gawk shared-mime-info groff libstroke ];

  configureFlags = [
    "--disable-update-xdg-database"
  ];

  CFLAGS = [
    "-DSCM_DEBUG_TYPING_STRICTNESS=2"
  ];

  postInstall = ''
    libs="${lib.makeLibraryPath propagatedBuildInputs}"
    for program in $out/bin/*
    do
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
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tesq0 ];
  };

}
