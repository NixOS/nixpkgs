{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2025-08-28";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "4103956c4300902436b03d7da482536e757b3601";
    hash = "sha256-QIjDAbPfbdV+V4RV6v8/85YTxiRbXLBlulObXpkPmxQ=";
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
