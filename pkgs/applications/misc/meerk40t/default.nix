{ lib
, fetchFromGitHub
, meerk40t-camera
, python3
, gtk3
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "MeerK40t";
  version = "0.8.1000";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "meerk40t";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-YCcnqaH4Npmct5IBHsnufswRz8bS7mUb1YFwTta/Dxc=";
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
    wxpython
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  nativeCheckInputs = with python3.pkgs; [
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
