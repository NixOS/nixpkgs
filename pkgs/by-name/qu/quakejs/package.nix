{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  fetchpatch,
  unzip,
  opusTools,
  zip,
}:

buildNpmPackage rec {
  pname = "quakejs";
  version = "0-unstable-2019-03-26";

  src = fetchFromGitHub {
    owner = "inolen";
    repo = "quakejs";
    rev = "977b188e05b239b6c48d7ecda9d04e9ca03f1578";
    hash = "sha256-PguDia4sikSP8bS6gG73o+EoEwOTAEice87Lng6mG74=";
  };

  patches = [
    # Accept EULA via environment variable
    ./eula_env.patch

    # Fix repak.js on newer versions of node
    # https://github.com/inolen/quakejs/pull/70
    (fetchpatch {
      url = "https://github.com/inolen/quakejs/commit/9a29f01ae91a49b1cd72b7c24cebfb691da7d4a1.patch";
      hash = "sha256-BXzue3F8hOjsBDWf1zJiE6YDzjOtCP6dm/cNd8+SbJM=";
      name = "fix_repak_js_compatibility.patch";
    })

  ];

  nativeBuildInputs = [ makeWrapper ];

  prePatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  npmDepsHash = "sha256-b/qUZw3OnfQiWMuNiORzyC9LR3J7kpATy73E5PQa+LU=";

  dontNpmBuild = true;

  postInstall = ''
    makeWrapper ${lib.getExe nodejs} "$out/bin/quakejs-ded" \
      --add-flags "$out/lib/node_modules/quakejs/build/ioq3ded.js"
    makeWrapper ${lib.getExe nodejs} "$out/bin/quakejs" \
      --add-flags "$out/lib/node_modules/quakejs/bin/web.js"
    makeWrapper ${lib.getExe nodejs} "$out/bin/quakejs-repak" \
      --prefix PATH : "${
        lib.makeBinPath [
          unzip
          opusTools
          zip
        ]
      }" \
      --add-flags "$out/lib/node_modules/quakejs/bin/repak.js"
  '';

  meta = {
    description = "Port of ioquake3 to JavaScript with the help of Emscripten";
    homepage = "http://www.quakejs.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.all;
  };
}
