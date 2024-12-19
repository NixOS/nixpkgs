{
  stdenvNoCC,
  lib,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "catamaran";
  version = "0-unstable-2024-03-02";

  src = fetchzip {
    url = "https://www.1001fonts.com/download/catamaran.zip";
    stripRoot = false;
    hash = "sha256-9s11lZSS4pYJZwl8Uk7qtdwfZ2bkoZkSIf1MkQlv7H4=";
  };

  stripRoot = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv *.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://fonts.google.com/specimen/Catamaran";
    description = "A stylish sans-serif Tamil and Latin typeface";
    longDescription = ''
      Catamaran is a Unicode-compliant Latin and Tamil text type family designed for the digital age.
      The Tamil is monolinear and was designed alongside the sans serif Latin and Devanagari family Palanquin.

      It currently comprises of 9 text weights, making it a versatile family that strikes a balance between typographic conventions and that bit of sparkle.
      (A catamaran is a multihulled vessel consisting of two parallel hulls of equal size.
      The catamaran concept is a relative newcomer for Western boat designers, been used since time immemorial among the Dravidian people, in South India.)
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
