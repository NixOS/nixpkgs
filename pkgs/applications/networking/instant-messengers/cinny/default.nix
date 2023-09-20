{ lib, buildNpmPackage, fetchFromGitHub, writeText, jq, conf ? { } }:

let
  configOverrides = writeText "cinny-config-overrides.json" (builtins.toJSON conf);
in
buildNpmPackage rec {
  pname = "cinny";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny";
    rev = "v${version}";
    hash = "sha256-Da/gbq9piKvkIMiamoafcRrqxF7128GXoswk2C43An8=";
  };

  npmDepsHash = "sha256-3wgB/dQmLtwxbRsk+OUcyfx98vpCvhvseEOCrJIFohY=";

  nativeBuildInputs = [
    jq
  ];

  installPhase = ''
    runHook preInstall

    cp -r dist $out
    jq -s '.[0] * .[1]' "config.json" "${configOverrides}" > "$out/config.json"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet another Matrix client for the web";
    homepage = "https://cinny.in/";
    maintainers = with maintainers; [ abbe ];
    license = licenses.agpl3Only;
    platforms = platforms.all;
  };
}
