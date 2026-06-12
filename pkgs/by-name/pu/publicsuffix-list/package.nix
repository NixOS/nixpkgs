{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2026-05-13";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "e452c7058d6946bd76952b128c12f5ce87a5acb8";
    hash = "sha256-5D4RZAyJOL4hMU32Rmp3SYmjgqEtF36mZJr4YBG0k7E=";
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
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
}
