{
  lib,
  fetchFromGitea,
  buildNpmPackage,
  writeText,
  # https://codeberg.org/emersion/gamja/src/branch/master/doc/config-file.md
  gamjaConfig ? null,
}:
buildNpmPackage rec {
  pname = "gamja";
  version = "1.0.0-beta.11";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "emersion";
    repo = "gamja";
    rev = "v${version}";
    hash = "sha256-amwJ6PWS0In7ERcvZr5XbJyHedSwJGAUUS2vWIqktNE=";
  };

  npmDepsHash = "sha256-5YU9H3XHwZADdIvKmS99cAFFg69GPJzD9u0LOuJmKXE=";

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
    homepage = "https://codeberg.org/emersion/gamja";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      motiejus
      apfelkuchen6
    ];
  };
}
