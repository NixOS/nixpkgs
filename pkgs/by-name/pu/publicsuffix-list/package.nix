{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "6cd82aff889e3d64e5e03bc5c1f43da1934a960a";
    hash = "sha256-qDArgrxZRNF1h6auydddeR91zyvTmMvPa4DSLc/6tUQ=";
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
