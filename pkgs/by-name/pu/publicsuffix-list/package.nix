{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2026-10-22";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "8437e5262f13305f94087abe699b4fe2be1d1de8";
    hash = "sha256-b8r5D3whhAF+TjFLw22J6TqgSHaSjfWOBgg+PB5vdAk=";
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
