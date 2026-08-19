{
  python3Packages,
  src,
  version,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  inherit src version;
  pname = "flatpak-go-get-generator";
  pyproject = false;

  sourceRoot = "${finalAttrs.src.name}/go-get";

  postInstall = ''
    install -D flatpak-go-get-generator.py $out/bin/flatpak-go-get-generator
  '';

  installCheckPhase = ''
    $out/bin/flatpak-go-get-generator --help
  '';
})
