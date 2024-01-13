{ buildPythonApplication
, python3
, poetry-core
, yubikey-manager
, fido2
, mss
, zxing-cpp
, pillow
, cryptography

, src
, version
, meta
}:

buildPythonApplication {
  pname = "yubioath-flutter-helper";
  inherit src version meta;

  sourceRoot = "${src.name}/helper";
  format = "pyproject";

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
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
    poetry-core
    yubikey-manager
    fido2
    mss
    zxing-cpp
    pillow
    cryptography
  ];
}
