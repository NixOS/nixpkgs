{
  python3Packages,
  src,
  version,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  inherit src version;
  pname = "flatpak-node-generator";
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/node";

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    aiohttp
    pyyaml
  ];

  installCheckPhase = ''
    $out/bin/flatpak-node-generator --help
  '';
})
