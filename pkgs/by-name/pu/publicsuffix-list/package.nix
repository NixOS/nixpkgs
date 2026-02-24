{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2025-11-14";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "64ba165cf391818a086139239c8fa223264eebcc";
    hash = "sha256-Ugou4SzYx9EtzcBtocCqhCZZaU1Sngvk1IEVAIJZ4KY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm0444 public_suffix_list.dat tests/test_psl.txt -t $out/share/publicsuffix

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = lib.platforms.all;
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.c0bw3b ];
  };
}
