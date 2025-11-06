{
  lib,
  darwin,
  fetchzip,
  ocamlPackages,
  ocaml,
  removeReferencesTo,
  soupault,
  stdenv,
  testers,
}:

ocamlPackages.buildDunePackage rec {
  pname = "soupault";
  version = "5.1.0";

  minimalOCamlVersion = "4.13";

  src = fetchzip {
    urls = [
      "https://github.com/PataphysicalSociety/soupault/archive/${version}.tar.gz"
      "https://codeberg.org/PataphysicalSociety/soupault/archive/${version}.tar.gz"
    ];
    hash = "sha256-yAkJgNwF763b2DFGA+4Ve+jafFxZbFDm3QxisDD6gYo=";
  };

  nativeBuildInputs = [
    removeReferencesTo
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    darwin.sigtool
  ];

  buildInputs = with ocamlPackages; [
    base64
    camomile
    cmarkit
    containers
    csv
    digestif
    ezjsonm
    fileutils
    fmt
    jingoo
    lambdasoup
    lua-ml
    logs
    markup
    odate
    otoml
    re
    spelll
    tsort
    yaml
  ];

  postFixup = ''
    find "$out" -type f -exec remove-references-to -t ${ocaml} '{}' +
  '';

  passthru.tests.version = testers.testVersion {
    package = soupault;
    command = "soupault --version-number";
  };

  meta = {
    description = "Tool that helps you create and manage static websites";
    homepage = "https://soupault.app/";
    changelog = "https://codeberg.org/PataphysicalSociety/soupault/src/branch/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ];
    mainProgram = "soupault";
  };
}
