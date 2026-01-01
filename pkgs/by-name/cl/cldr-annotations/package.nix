{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cldr-annotations";
<<<<<<< HEAD
  version = "48";
=======
  version = "46.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchzip {
    url = "https://unicode.org/Public/cldr/${version}/cldr-common-${version}.zip";
    stripRoot = false;
<<<<<<< HEAD
    hash = "sha256-Q+dA8Y4VfO8abyHRVgoRQMfY5NG6vZn/ZorxF/SEOmo=";
=======
    hash = "sha256-HNQVVbUIjsGOnkzUlH2m8I0IDgEfy2omCTekZlSyXQI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode/cldr/common
    mv common/annotations{,Derived} -t $out/share/unicode/cldr/common

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Names and keywords for Unicode characters from the Common Locale Data Repository";
    homepage = "https://cldr.unicode.org";
    license = lib.licenses.unicode-30;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ DeeUnderscore ];
=======
  meta = with lib; {
    description = "Names and keywords for Unicode characters from the Common Locale Data Repository";
    homepage = "https://cldr.unicode.org";
    license = licenses.unicode-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ DeeUnderscore ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
