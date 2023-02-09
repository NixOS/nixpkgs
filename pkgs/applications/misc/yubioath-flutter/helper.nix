{ buildPythonApplication
, poetry-core
, yubikey-manager
, fido2
, mss
, zxing_cpp
, pillow
, cryptography

, src
, version
, meta
}:

buildPythonApplication {
  pname = "yubioath-flutter-helper";
  inherit src version meta;

  sourceRoot = "source/helper";
  format = "pyproject";

  postPatch = ''
    sed -i \
      -e 's,zxing-cpp = .*,zxing-cpp = "*",g' \
      -e 's,mss = .*,mss = "*",g' \
      pyproject.toml
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
    zxing_cpp
    pillow
    cryptography
  ];
}
