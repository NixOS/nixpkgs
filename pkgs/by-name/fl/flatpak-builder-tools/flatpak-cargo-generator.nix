{
  python3Packages,
  src,
  version,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  inherit src version;
  pname = "flatpak-cargo-generator";
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/cargo";

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aiohttp
    pyyaml
    tomlkit
  ];

  postInstall = ''
    install -D flatpak-cargo-generator.py $out/bin/flatpak-cargo-generator
  '';

  installCheckPhase = ''
    $out/bin/flatpak-cargo-generator --help
  '';
})
