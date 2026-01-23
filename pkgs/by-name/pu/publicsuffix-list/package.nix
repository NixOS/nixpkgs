{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2025-12-28";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "1ef6d3bc102c85d12e92be54ec0dad8ee990dd5f";
    hash = "sha256-rQdum6XLgfXwzpKTneakFmC80tOmlPFrZ8C7dfEnlSo=";
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
