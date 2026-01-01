{
  appimageTools,
  lib,
  fetchurl,
<<<<<<< HEAD
  makeWrapper,
}:
let
  pname = "mathpix-snipping-tool";
  version = "03.00.0138";

  src = fetchurl {
    url = "https://download.mathpix.com/linux/Mathpix_Snipping_Tool-x86_64.v${version}.AppImage";
    sha256 = "sha256-29iLdrWxqLL7uRfHae8Mq+w9yaGtM9Y5vRLzYESgzBs=";
=======
}:
let
  pname = "mathpix-snipping-tool";
  version = "03.00.0072";

  src = fetchurl {
    url = "https://download.mathpix.com/linux/Mathpix_Snipping_Tool-x86_64.v${version}.AppImage";
    sha256 = "1igg8wnshmg9f23qqw1gqb85h1aa3461c1n7dmgw6sn4lrrrh5ms";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

<<<<<<< HEAD
  nativeBuildInputs = [ makeWrapper ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications

    cp -r ${appimageContents}/usr/share/icons $out/share
<<<<<<< HEAD

    wrapProgram $out/bin/${pname} --set QT_QPA_PLATFORM xcb
  '';

  meta = {
    description = "OCR tool to convert pictures to LaTeX";
    homepage = "https://mathpix.com/";
    license = lib.licenses.unfree;
    maintainers = [
      lib.maintainers.hiro98
      lib.maintainers.axodentally
    ];
=======
  '';

  meta = with lib; {
    description = "OCR tool to convert pictures to LaTeX";
    homepage = "https://mathpix.com/";
    license = licenses.unfree;
    maintainers = [ maintainers.hiro98 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-linux" ];
    mainProgram = "mathpix-snipping-tool";
  };
}
