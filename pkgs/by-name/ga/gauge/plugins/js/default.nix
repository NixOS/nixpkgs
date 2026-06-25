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
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge-js";
    rev = "v${version}";
    hash = "sha256-JkASdQX+No909UsEQfeACc9Tym6f65mFoZQZsJNxmQU=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-BtXb1rmi3WOsmzRhn5GS0rk6nV1ZY0HOKXG87MgGtT0=";
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
