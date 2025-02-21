{
  stdenv,
  lib,
  fetchFromGitHub,
  python3Packages,
  mkDerivationWith,
}:
with python3Packages; mkDerivationWith buildPythonPackage rec {
  pname = "plover";
  version = "4.0.0rc2";
  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "OpenSteno Plover stenography software";
    maintainers = with maintainers; [
      twey
      kovirobi
    ];
    license = licenses.gpl2;
  };

  src = fetchFromGitHub {
    owner = "openstenoproject";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rmMec/BbvOJ92u8Tmp3Kv2YezzJxB/L8UrDntTDSKj4=";
  };

  # I'm not sure why we don't find PyQt5 here but there's a similar
  # sed on many of the platforms Plover builds for
  postPatch = "sed -i /PyQt5/d setup.cfg";

  nativeCheckInputs = [
    pytest
    mock
  ];
  propagatedBuildInputs = [
    babel
    pyqt5
    xlib
    pyserial
    appdirs
    wcwidth
    rtf-tokenize
    plover-stroke
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';
}
