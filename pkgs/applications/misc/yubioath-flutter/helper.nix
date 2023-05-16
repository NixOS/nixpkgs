{ buildPythonApplication
<<<<<<< HEAD
, python3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
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
=======
  sourceRoot = "source/helper";
  format = "pyproject";

  postPatch = ''
    sed -i \
      -e 's,zxing-cpp = .*,zxing-cpp = "*",g' \
      -e 's,mss = .*,mss = "*",g' \
      pyproject.toml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
