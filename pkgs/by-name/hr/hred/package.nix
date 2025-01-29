{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  hred,
  jq,
}:

buildNpmPackage rec {
  pname = "hred";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "danburzo";
    repo = "hred";
    rev = "v${version}";
    hash = "sha256-+0+WQRI8rdIMbPN0eBUdsWUMWDCxZhTRLiFo1WRd2xc=";
  };

  npmDepsHash = "sha256-kNNvSxZqN6cDZIG+lvqxgjAVCJUJrCvZThxrur5kozU=";

  dontNpmBuild = true;

  passthru.tests = {
    simple = runCommand "${pname}-test" { } ''
      set -e -o pipefail
      echo '<i id="foo">bar</i>' | ${hred}/bin/hred 'i#foo { @id => id, @.textContent => text }' -c | ${jq}/bin/jq -c > $out
      [ "$(cat $out)" = '{"id":"foo","text":"bar"}' ]
    '';
  };

  meta = {
    description = "Command-line tool to extract data from HTML";
    mainProgram = "hred";
    license = lib.licenses.mit;
    homepage = "https://github.com/danburzo/hred";
    maintainers = with lib.maintainers; [ tejing ];
  };
}
