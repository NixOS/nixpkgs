{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "office-code-pro";
  version = "1.004";

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "phooky";
=======
    owner = "nathco";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    repo = "Office-Code-Pro";
    rev = version;
    hash = "sha256-qzKTXYswkithZUJT0a3IifCq4RJFeKciZAPhYr2U1X4=";
  };

  installPhase = ''
    runHook preInstall

    install -m644 -Dt $out/share/doc/${pname}-${version} README.md
    install -m444 -Dt $out/share/fonts/opentype 'Fonts/Office Code Pro/OTF/'*.otf 'Fonts/Office Code Pro D/OTF/'*.otf

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Customized version of Source Code Pro";
    longDescription = ''
      Office Code Pro is a customized version of Source Code Pro, the monospaced
      sans serif originally created by Paul D. Hunt for Adobe Systems
      Incorporated. The customizations were made specifically for text editors
      and coding environments, but are still very usable in other applications.
    '';
<<<<<<< HEAD
    homepage = "https://github.com/phooky/Office-Code-Pro";
    license = lib.licenses.ofl;
=======
    homepage = "https://github.com/nathco/Office-Code-Pro";
    license = licenses.ofl;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
