{
  lib,
  stdenvNoCC,
  fetchzip,
  python3Packages,
}:

stdenvNoCC.mkDerivation rec {
  pname = "roboto";
  version = "2.138";

  src = fetchzip {
    url = "https://github.com/google/roboto/releases/download/v${version}/roboto-unhinted.zip";
    stripRoot = false;
    hash = "sha256-ue3PUZinBpcYgSho1Zrw1KHl7gc/GlN1GhWFk6g5QXE=";
  };

  nativeBuildInputs = [
    python3Packages.fonttools
  ];

  installPhase = ''
    runHook preInstall

    # The RobotoCondensed fonts have a usWidthClass value of 5, which is
    # incorrect. It should be 3.
    # See the corresponding issue at https://github.com/googlefonts/roboto-3-classic/issues/130
    for file in RobotoCondensed*; do
      fontname=$(echo $file | sed 's/\.ttf//')
      ttx -v -o $fontname.xml $file
      substituteInPlace $fontname.xml \
        --replace-fail "<usWidthClass value=\"5\"/>" "<usWidthClass value=\"3\"/>"
      ttx $fontname.xml -o $fontname.ttf
    done

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/google/roboto";
    description = "Roboto family of fonts";
    longDescription = ''
      Google’s signature family of fonts, the default font on Android and
      Chrome OS, and the recommended font for Google’s visual language,
      Material Design.
    '';
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.romildo ];
  };
}
