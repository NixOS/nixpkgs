{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_latest,
  runCommand,
  grok-cli,
}:

buildNpmPackage rec {
  pname = "grok-cli";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "superagent-ai";
    repo = "grok-cli";
    rev = "@vibe-kit/grok-cli@${version}";
    hash = "sha256-4+be/H/LEMNxNTYHW7L4wDIKPm09yuYo4r08ZeBiJ4w=";
  };

  npmDepsHash = "sha256-Yl51fCnI3soQ4sGBg4dr+kVak8zYEkMTgyUKDaRK6N0=";

  nativeBuildInputs = [ nodejs_latest ];

  passthru.tests = {
    help-command = runCommand "grok-help-test" { } ''
      output="$(${grok-cli}/bin/grok --help)"
      echo "$output" > $out

      echo "$output" | grep -Eq "Usage: grok.+"
    '';
  };

  meta = with lib; {
    description = "AI agent CLI powered by Grok";
    homepage = "https://github.com/superagent-ai/grok-cli";
    license = licenses.mit;
    maintainers = [ maintainers.madebydamo ];
    mainProgram = "grok";
    platforms = platforms.all;
  };
}
