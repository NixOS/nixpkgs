{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2026-09-08";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "3955e3ec29b94c3cca7bd4509c5f14a7c0959e26";
    hash = "sha256-rVuhaaUr/h4GJhHA7oG6Gkcm90yrFsZONlHpP8ldsAU=";
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
