{
  buildPythonPackage,
  hatchling,
  pyyaml,
  ua-parser,
  versioningit,
}:

buildPythonPackage rec {
  pname = "ua-parser-builtins";
  inherit (ua-parser) version src;
  pyproject = true;

  sourceRoot = "${src.name}/ua-parser-builtins";

  postPatch = ''
    # break dependency cycle and don't use git to determine version
    substituteInPlace pyproject.toml \
      --replace-fail 'dependencies = ["ua-parser"]' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    hatchling
    pyyaml
    versioningit
  ];
}
