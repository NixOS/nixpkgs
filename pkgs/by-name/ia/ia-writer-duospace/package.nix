{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "ia-writer-duospace";
  version = "unstable-2018-07-21";

  src = fetchFromGitHub {
    owner = "iaolo";
    repo = "iA-Fonts";
    rev = "55edf60f544078ab1e14987bc67e9029a200e0eb";
    hash = "sha256-/ifzOScILLuFkjFIgpy0ArCcelgealbpypKvZ46xApU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    cp "iA Writer Duospace/OTF (Mac)/"*.otf $out/share/fonts/opentype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "iA Writer Duospace Typeface";
    homepage = "https://ia.net/topics/in-search-of-the-perfect-writing-font";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
