{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "quicksand";
  version = "2.0-unstable-2021-01-15";

  src = fetchFromGitHub {
    owner = "andrew-paglinawan";
    repo = "QuicksandFamily";
    rev = "be4b9d638e1c79fa42d4a0ab0aa7fe29466419c7";
    hash = "sha256-zkxm2u35Ll2qyCoUeuA0eumVjNSel+y1kkWoHxeNI/g=";
    sparseCheckout = ["fonts"];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/quicksand

    install -Dm444 fonts/*.ttf -t $out/share/fonts/quicksand/
    install -Dm444 fonts/statics/*.ttf -t $out/share/fonts/quicksand/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/andrew-paglinawan/QuicksandFamily";
    description = "A sans serif font designed using geometric shapes";
    longDescription = ''
      Quicksand is a sans serif typeface designed by Andrew Paglinawan
      in 2008 using geometric shapes as it's core foundation. It is
      designed for display purposes but legible enough to use in small
      sizes as well. Quicksand Family is available in three styles
      which are Light, Regular and Bold including true italics for each weight.
    '';
    license = with lib.licenses; [ ofl ];
    maintainers = with lib.maintainers; [ hubble ];
    platforms = lib.platforms.all;
  };
}
