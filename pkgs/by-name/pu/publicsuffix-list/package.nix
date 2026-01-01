{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
<<<<<<< HEAD
  version = "0-unstable-2025-11-14";
=======
  version = "0-unstable-2025-10-08";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
<<<<<<< HEAD
    rev = "64ba165cf391818a086139239c8fa223264eebcc";
    hash = "sha256-Ugou4SzYx9EtzcBtocCqhCZZaU1Sngvk1IEVAIJZ4KY=";
=======
    rev = "ee7dec4a99602baaf51879dd8469b6642881a494";
    hash = "sha256-IlR3dICad9EZeizI3V0A1YCQZiV/xg2GxtmTLG4EASU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm0444 public_suffix_list.dat tests/test_psl.txt -t $out/share/publicsuffix

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

<<<<<<< HEAD
  meta = {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = lib.platforms.all;
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.c0bw3b ];
=======
  meta = with lib; {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = platforms.all;
    license = licenses.mpl20;
    maintainers = [ maintainers.c0bw3b ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
