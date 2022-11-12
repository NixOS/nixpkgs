{ lib
, fetchFromGitHub
, python3
, gtk3
, wrapGAppsHook
}:

let
  inherit (python3.pkgs) buildPythonApplication buildPythonPackage fetchPypi;

  meerk40t-camera = buildPythonPackage rec {
    pname = "meerk40t-camera";
    version = "0.1.9";
    format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-uGCBHdgWoorVX2XqMCg0YBweb00sQ9ZSbJe8rlGeovs=";
    };

    postPatch = ''
      sed -i '/meerk40t/d' setup.py
    '';

    propagatedBuildInputs = with python3.pkgs; [
      opencv4
    ];

    pythonImportsCheck = [
      "camera"
    ];

    doCheck = false;

    meta = with lib; {
      description = "MeerK40t camera plugin";
      license = licenses.mit;
      homepage = "https://github.com/meerk40t/meerk40t-camera";
      maintainers = with maintainers; [ hexa ];
    };
  };
in
buildPythonApplication rec {
  pname = "MeerK40t";
  version = "0.8.0031";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "meerk40t";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7Vc7Z+mxy+xRbUBeivkqVwO86ovZDo42M4G0ZD23vMk=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  # prevent double wrapping
  dontWrapGApps = true;

  propagatedBuildInputs = with python3.pkgs; [
    ezdxf
    meerk40t-camera
    opencv4
    pillow
    pyserial
    pyusb
    setuptools
    wxPython_4_2
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  checkInputs = with python3.pkgs; [
    unittestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    changelog = "https://github.com/meerk40t/meerk40t/releases/tag/${version}";
    description = "MeerK40t LaserCutter Software";
    homepage = "https://github.com/meerk40t/meerk40t";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
