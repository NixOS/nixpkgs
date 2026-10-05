{
  python3Packages,
  src,
  version,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  inherit src version;
  pname = "flatpak-json2yaml";
  pyproject = false;

  sourceRoot = "${finalAttrs.src.name}/flatpak-json2yaml";

  dependencies = with python3Packages; [
    pyyaml
  ];

  postInstall = ''
    install -D flatpak-json2yaml.py $out/bin/flatpak-json2yaml
  '';

  installCheckPhase = ''
    $out/bin/flatpak-json2yaml --help
  '';
})
