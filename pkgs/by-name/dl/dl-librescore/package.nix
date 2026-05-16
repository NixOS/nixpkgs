{
  buildNpmPackage,
  cctools,
  fetchFromGitHub,
  fetchpatch,
  lib,
  nix-update-script,
  nodejs_22,
  python3Minimal,
  stdenvNoCC,
}:

buildNpmPackage (finalAttrs: {
  pname = "dl-librescore";
  version = "0.35.40";

  src = fetchFromGitHub {
    owner = "LibreScore";
    repo = "dl-librescore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jCwySndc3ZeEoKVA9Ne2PLStyM73hDPO1vaNeVShwQ0=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-8x1WuzIaxzaEgM9hu2cCtXr4GLCE6DHt3F7lvnbcMgk=";
  npmDepsFetcherVersion = 2;

  makeCacheWritable = true;

  nativeBuildInputs = [
    python3Minimal
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [ cctools ];

  patches = [
    # https://github.com/LibreScore/dl-librescore/pull/144
    (fetchpatch {
      name = "update-pdfkit.patch";
      url = "https://github.com/LibreScore/dl-librescore/commit/3694697d2d3f3f59ca32ee962999b3dd22c81de7.patch";
      hash = "sha256-ikEJNwKMDWpWBQnS3ur76vZqF+zRI6D5d0AyLDdreJY=";
    })
  ];

  postPatch = ''
    for file in src/i18n/*.json; do
      substituteInPlace "$file" --replace-quiet \
        'Run npm i -g dl-librescore@{{latest}} to update' ""
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Download sheet music";
    homepage = "https://github.com/LibreScore/dl-librescore";
    license = lib.licenses.mit;
    mainProgram = "dl-librescore";
    maintainers = with lib.maintainers; [ yiyu ];
  };
})
