{
  python3Packages,
  src,
  version,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  inherit src version;
  pname = "flatpak-dotnet-generator";
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/dotnet";

  build-system = with python3Packages; [ setuptools ];

  postInstall = ''
    install -D flatpak-dotnet-generator.py $out/bin/flatpak-dotnet-generator
  '';

  installCheckPhase = ''
    $out/bin/flatpak-dotnet-generator --help
  '';
})
