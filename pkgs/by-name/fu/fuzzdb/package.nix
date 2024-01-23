{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation  {
  pname = "fuzzdb";
  version = "0-unstable-2020-02-26";

  src = fetchFromGitHub {
    owner = "fuzzdb-project";
    repo = "fuzzdb";
    rev = "5656ab25dc6bb43bae32236fab775658a90d7380";
    hash = "sha256-7AORrXi443+VK5lbgcjqW4QS7asbXu/dCKj8uCMC0PY=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/wordlists/fuzzdb
    cp -a * $out/share/wordlists/fuzzdb
    runHook postInstall
  '';

  meta = {
    description = "A comprehensive collection of attack patterns and predictable resource names used for security testing and fuzzing application";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ shard7 ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
