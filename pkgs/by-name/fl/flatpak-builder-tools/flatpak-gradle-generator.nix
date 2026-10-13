{
  python3Packages,
  src,
  version,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  inherit src version;
  pname = "flatpak-gradle-generator";
  pyproject = false;

  sourceRoot = "${finalAttrs.src.name}/gradle";

  dependencies = with python3Packages; [
    aiohttp
  ];

  postInstall = ''
    install -D flatpak-gradle-generator.py $out/bin/flatpak-gradle-generator
  '';

  installCheckPhase = ''
    $out/bin/flatpak-gradle-generator --help
  '';
})
