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
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge-js";
    rev = "v${version}";
    hash = "sha256-CFjwdfU7KjYcG9EGF76j4iNXZqD5eGTsxbk2s//EKJ4=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-R6XYgeVD8NlgLyqZywzeTBebYG5T4qdSUwEH73+nKRA=";
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
