{
  lib,
  nodejs,
  buildNpmPackage,
  fetchFromGitHub,
  unzip,
  gauge-unwrapped,
}:
buildNpmPackage rec {
  pname = "gauge-plugin-js";
  version = "5.0.8";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge-js";
    rev = "v${version}";
    hash = "sha256-ET5R5CCz8fEcgsBeCJ8KmLkasS5zWSO56dJQgSiD/Cs=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-lVd0hO5efxvBuvVgb7adWR7kkzrWj0vitpXAkM1jfPY=";
  npmBuildScript = "package";

  buildInputs = [ nodejs ];
  nativeBuildInputs = [ unzip ];

  postPatch = ''
    patchShebangs index.js
  '';

  installPhase = ''
    mkdir -p $out/share/gauge-plugins/js/${version}
    unzip deploy/gauge-js-${version}.zip -d $out/share/gauge-plugins/js/${version}
  '';

  meta = {
    description = "Gauge plugin that lets you write tests in JavaScript";
    homepage = "https://github.com/getgauge/gauge-js/";
    license = lib.licenses.mit;
    maintainers = [ ];
    inherit (gauge-unwrapped.meta) platforms;
  };
}
