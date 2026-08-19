{
  python3Packages,
  src,
  version,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  inherit src version;
  pname = "flatpak-poetry-generator";
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/poetry";

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    toml
  ];

  postInstall = ''
    install -D flatpak-poetry-generator.py $out/bin/flatpak-poetry-generator
  '';

  installCheckPhase = ''
    $out/bin/flatpak-poetry-generator --help
  '';
})
