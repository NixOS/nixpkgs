{ stdenv
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
, pcre
, pkgconfig
}:
let
  rev   = "v0.6-17-g271e784";
in
stdenv.mkDerivation rec {
  pname = "neocomp-unstable";
  version = "2019-03-12";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "DelusionalLogic";
    repo   = "NeoComp";
    sha256 = "1mp338vz1jm5pwf7pi5azx4hzykmvpkwzx1kw6a9anj272f32zpg";
  };

  buildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
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
    pcre
    pkgconfig
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CFGDIR=${placeholder "out"}/etc/xdg/neocomp"
    "ASTDIR=${placeholder "out"}/share/neocomp/assets"
    "COMPTON_VERSION=git-${rev}-${version}"
  ];

  postPatch = ''
    substituteInPlace src/compton.c --replace \
      "assets_add_path(\"./assets/\");" \
      "assets_add_path(\"$out/share/neocomp/assets/\");"
    substituteInPlace src/assets/assets.c --replace \
      "#define MAX_PATH_LENGTH 64" \
      "#define MAX_PATH_LENGTH 128"
  '';

  meta = with stdenv.lib; {
    homepage        = "https://github.com/DelusionalLogic/NeoComp";
    license         = licenses.gpl3;
    maintainers     = with maintainers; [ twey ];
    platforms       = platforms.linux;
    description     = "A fork of Compton, a compositor for X11";
    longDescription = ''
      NeoComp is a (hopefully) fast and (hopefully) simple compositor
      for X11, focused on delivering frames from the window to the
      framebuffer as quickly as possible.
    '';
  };
}
