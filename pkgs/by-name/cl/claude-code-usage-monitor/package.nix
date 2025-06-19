{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
  ccusage,
  nix-update-script,
}:

let
  pythonEnv = python3.withPackages (ps: [ ps.pytz ]);

in
stdenv.mkDerivation rec {
  pname = "claude-code-usage-monitor";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "Maciek-roboblog";
    repo = "Claude-Code-Usage-Monitor";
    tag = "v${version}";
    hash = "sha256-2tm1S3a2KlEEd+ajKN8gVp8ju34v2ueryxJtynvOEtQ=";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ ccusage ];
  passthru.updateScript = nix-update-script { };

  installPhase = ''
    runHook preInstall

      mkdir -p $out/bin $out/share/claude-code-usage-monitor
      cp ccusage_monitor.py $out/share/claude-code-usage-monitor/
      makeWrapper ${pythonEnv}/bin/python $out/bin/claude-code-usage-monitor \
        --add-flags "$out/share/claude-code-usage-monitor/ccusage_monitor.py" \
        --prefix PATH : ${ccusage}/bin

      runHook postInstall
  '';

  meta = {
    description = "Real-time Claude Code usage monitor with predictions and warnings";
    mainProgram = "claude-code-usage-monitor";
    homepage = "https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eleloi ];
  };
}
