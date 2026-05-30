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
  version = "5.0.5";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge-js";
    rev = "v${version}";
    hash = "sha256-qWnBx6bvut/bSvFC8WPAetyAsF16Wz99Pq0tGg+YpZw=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-HD1JsAewyzoUPKFwtpGGwjHWmYUpLSN3Spb5FW+3d10=";
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
    maintainers = with lib.maintainers; [ marie ];
    inherit (gauge-unwrapped.meta) platforms;
  };
}
