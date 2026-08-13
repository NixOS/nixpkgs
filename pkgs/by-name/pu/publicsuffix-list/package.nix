{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2026-07-25";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "e1b8015c3b2f0f4f8c18659c2480fc1a22c07b20";
    hash = "sha256-F+OmANpg7I4dBFL7PM3oJlhpDzfxrRTfo+50lQHdU2M=";
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
  };
}
