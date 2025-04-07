{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2025-02-12";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "560007a8aea8267f15cad9abcdbcff7848186bd8";
    hash = "sha256-/5O0ac0mJZzOgy8h1NE0dTt0jzAEkymBbh5hJmc1+qk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm0444 public_suffix_list.dat tests/test_psl.txt -t $out/share/publicsuffix

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = platforms.all;
    license = licenses.mpl20;
    maintainers = [ maintainers.c0bw3b ];
  };
}
