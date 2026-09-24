{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2026-09-24";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "a179a48c465e818cfd8d626691cb317985da87fb";
    hash = "sha256-cge6jpqlyV31PDNBV/DqsSpSZR5dclXoARlSOTU/RvQ=";
  };

  dontBuild = true;

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -Dm0444 public_suffix_list.dat tests/test_psl.txt -t $out/share/publicsuffix

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  __structuredAttrs = true;

  meta = {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = lib.platforms.all;
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
