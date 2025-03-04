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
  version = "1.0.0-beta.10";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "emersion";
    repo = "gamja";
    rev = "v${version}";
    hash = "sha256-JqnEiPnYRGSeIZm34Guu7MgMfwcySc42aTXweMqL8BQ=";
  };

  npmDepsHash = "sha256-dAfbluNNBF1e9oagej+SRxO/YffCdLLAUUgt8krnWvg=";

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
