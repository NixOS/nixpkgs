{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  fetchpatch,
  nodePackages,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildNpmPackage rec {
  pname = "osmtogeojson";
  version = "3.0.0-beta.5";

  src = fetchFromGitHub {
    owner = "tyrasd";
    repo = "osmtogeojson";
    rev = version;
    hash = "sha256-T6d/KQQGoXHgV0iNhOms8d9zfjYMfnBNwPLShrEkHG4=";
  };

<<<<<<< HEAD
  patches = [
    # Fix critical xmldom security issue
    # Se https://github.com/tyrasd/osmtogeojson/pull/146
    (fetchpatch {
      url = "https://github.com/tyrasd/osmtogeojson/commit/536ce2e9cfc3987b7596216223ce40dfbc9603e9.patch";
      hash = "sha256-+LRithLPalcTROoJXGim7S10rxlnLxfH5mvn0dkFKIo=";
    })
  ];

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
    # Fix 3 moderate-severity vulnerabilities
    substituteInPlace package.json --replace-fail '"mocha": "~10.1.0",' '"mocha": "^10.1.0",'
  '';

  npmDepsHash = "sha256-tjdws4+xIEFa67bfAumewaYjGjjGbTJOiXbcTp/285U=";
  dontNpmBuild = true;

  # "browserify: command not found"
  nativeBuildInputs = [ nodePackages.browserify ];
  postBuild = "patchShebangs osmtogeojson";

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    npm run test
    runHook postCheck
  '';

  meta = {
    description = "Converts OSM data to GeoJSON";
    homepage = "https://tyrasd.github.io/osmtogeojson/";
    maintainers = with lib.maintainers; [ thibautmarty ];
    license = lib.licenses.mit;
=======
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-stAVuyjuRQthQ3jQdekmZYjeau9l0GzEEMkV1q5fT2k=";
  dontNpmBuild = true;

  meta = with lib; {
    description = "Converts OSM data to GeoJSON";
    homepage = "https://tyrasd.github.io/osmtogeojson/";
    maintainers = with maintainers; [ thibautmarty ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "osmtogeojson";
  };
}
