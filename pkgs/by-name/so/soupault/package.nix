{
  lib,
  darwin,
  fetchzip,
  ocamlPackages,
  soupault,
  stdenv,
  testers,
}:

ocamlPackages.buildDunePackage rec {
  pname = "soupault";
  version = "4.10.0";

  minimalOCamlVersion = "4.13";

  src = fetchzip {
    urls = [
      "https://github.com/PataphysicalSociety/soupault/archive/${version}.tar.gz"
      "https://codeberg.org/PataphysicalSociety/soupault/archive/${version}.tar.gz"
    ];
    hash = "sha256-mkbRWw4Qj7pk2MQJERA9cAuC8DXD/fOShVXz2zPtXZ4=";
  };

  nativeBuildInputs = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ darwin.sigtool ];

  buildInputs = with ocamlPackages; [
    base64
    camomile
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

  passthru.tests.version = testers.testVersion {
    package = soupault;
    command = "soupault --version-number";
  };

  meta = {
    description = "A tool that helps you create and manage static websites";
    homepage = "https://soupault.app/";
    changelog = "https://codeberg.org/PataphysicalSociety/soupault/src/branch/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toastal ];
    mainProgram = "soupault";
  };
}
