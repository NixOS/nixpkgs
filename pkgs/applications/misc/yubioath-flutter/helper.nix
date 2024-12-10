{
  buildPythonApplication,
  yubikey-manager,
  mss,
  zxing-cpp,
  pillow,
  poetry-core,
  pythonRelaxDepsHook,

  src,
  version,
  meta,
}:

buildPythonApplication {
  pname = "yubioath-flutter-helper";
  inherit src version meta;

  pyproject = true;

  sourceRoot = "${src.name}/helper";

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "authenticator-helper" "yubioath-flutter-helper" \
      --replace "0.1.0" "${version}"
  '';

  postInstall = ''
    install -Dm 0755 authenticator-helper.py $out/bin/authenticator-helper
    install -d $out/libexec/helper
    ln -fs $out/bin/authenticator-helper $out/libexec/helper/authenticator-helper
  '';

  propagatedBuildInputs = [
    yubikey-manager
    mss
    zxing-cpp
    pillow
  ];
}
