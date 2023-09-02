# <https://github.com/castlabs/electron-releases>
{ buildNpmPackage
, fetchFromGitHub
, electron
}:

buildNpmPackage rec {
  pname = "castlabs-electron";
  version = "24.1.2+wvcus";

  src = fetchFromGitHub {
    owner = "castlabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vPl5SfSZ2CmZmekhtuoeaZPXCBnXVwLKh5+tHEH+hhE=";
  };

  ELECTRON_SKIP_BINARY_DOWNLOAD = true;
  ELECTRON_OVERRIDE_DIST_PATH = "${electron}/bin/";

  prePatch = ''
    substituteAll ${./package-lock.json} package-lock.json
  '';

  postInstall = ''
    cp package-lock.json $out/lib/node_modules/electron/
  '';

  dontNpmBuild = true;
  npmDepsHash = "sha256-h9X5ehvOlgAhw+HC6rlbh5PMGq+RlA6gqc40G5bBv5w=";
}
