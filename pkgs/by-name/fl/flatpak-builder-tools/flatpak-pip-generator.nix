{
  python3Packages,
  src,
  version,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  inherit src version;
  pname = "flatpak-pip-generator";
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/pip";

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    packaging
    pyyaml
    requirements-parser
    tomli
  ];

  postInstall = ''
    install -D flatpak-pip-generator.py $out/bin/flatpak-pip-generator
  '';

  installCheckPhase = ''
    $out/bin/flatpak-pip-generator --help
  '';
})
