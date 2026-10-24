{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2026-10-07";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "3929462652695bad04f0a27afb600974014a3c8b";
    hash = "sha256-gUnfhcR6Gm55HangcoA0Vymd2KzB5pckCdfYHLRcEJY=";
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
