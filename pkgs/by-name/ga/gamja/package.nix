{
  lib,
  fetchFromSourcehut,
  buildNpmPackage,
  writeText,
  # https://git.sr.ht/~emersion/gamja/tree/master/doc/config-file.md
  gamjaConfig ? null,
}:
buildNpmPackage rec {
  pname = "gamja";
  version = "1.0.0-beta.9";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "gamja";
    rev = "v${version}";
    hash = "sha256-09rCj9oMzldRrxMGH4rUnQ6wugfhfmJP3rHET5b+NC8=";
  };

  npmDepsHash = "sha256-LxShwZacCctKAfMNCUMyrSaI1hIVN80Wseq/d8WITkc=";

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    ${lib.optionalString (
      gamjaConfig != null
    ) "cp ${writeText "gamja-config" (builtins.toJSON gamjaConfig)} $out/config.json"}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple IRC web client";
    homepage = "https://git.sr.ht/~emersion/gamja";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      motiejus
      apfelkuchen6
    ];
  };
}
