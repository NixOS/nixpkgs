{ lib, stdenv
, fetchFromGitHub
, asciidoc
, docbook_xml_dtd_45
, docbook_xsl
, freetype
, judy
, libGL
, libconfig
, libdrm
, libxml2
, libxslt
, libXcomposite
, libXdamage
, libXext
, libXinerama
, libXrandr
, libXrender
, libXres
, pcre
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "neocomp";
  version = "unstable-2021-04-06";

  src = fetchFromGitHub {
    owner = "DelusionalLogic";
    repo = "NeoComp";
    rev = "ccd340d7b2dcd3f828aff958a638cc23686aee6f";
    sha256 = "sha256-tLLEwpAGNVTC+N41bM7pfskIli4Yvc95wH2/NT0OZ+8=";
  };

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    pkg-config
  ];

  buildInputs = [
    freetype
    judy
    libGL
    libconfig
    libdrm
    libxml2
    libxslt
    libXcomposite
    libXdamage
    libXext
    libXinerama
    libXrandr
    libXrender
    libXres
    pcre
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CFGDIR=${placeholder "out"}/etc/xdg/neocomp"
    "ASTDIR=${placeholder "out"}/share/neocomp/assets"
    "COMPTON_VERSION=${version}"
  ];

  postPatch = ''
    substituteInPlace src/compton.c --replace \
      "assets_add_path(\"./assets/\");" \
      "assets_add_path(\"$out/share/neocomp/assets/\");"
    substituteInPlace src/assets/assets.c --replace \
      "#define MAX_PATH_LENGTH 64" \
      "#define MAX_PATH_LENGTH 128"
  '';

  meta = with lib; {
    homepage        = "https://github.com/DelusionalLogic/NeoComp";
    license         = licenses.gpl3Only;
    maintainers     = with maintainers; [ twey moni ];
    platforms       = platforms.linux;
    description     = "A fork of Compton, a compositor for X11";
    longDescription = ''
      NeoComp is a (hopefully) fast and (hopefully) simple compositor
      for X11, focused on delivering frames from the window to the
      framebuffer as quickly as possible.
    '';
    mainProgram = "neocomp";
  };
}
