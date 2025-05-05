{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "dosis";
  version = "1.007";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Dosis";
    rev = "12df1e13e58768f20e0d48ff15651b703f9dd9dc";
    hash = "sha256-rZ49uNBlI+NWkiZykpyXzOonXlbVB6Vf6a/8A56Plj4=";
  };

  installPhase = ''
    runHook preInstall

    find . -name '*.otf' -exec install -m444 -Dt $out/share/fonts/opentype {} \;
    install -m444 -Dt $out/share/doc/${pname}-${version} README.md FONTLOG.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "Very simple, rounded, sans serif family";
    longDescription = ''
      Dosis is a very simple, rounded, sans serif family.

      The lighter weights are minimalist. The bolder weights have more
      personality. The medium weight is nice and balanced. The overall result is
      a family that's clean and modern, and can express a wide range of
      voices & feelings.

      It comes in 7 incremental weights: ExtraLight, Light, Book, Medium,
      Semibold, Bold & ExtraBold
    '';
    homepage = "http://www.impallari.com/dosis";
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
