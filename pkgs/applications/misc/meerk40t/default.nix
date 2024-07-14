{ lib
, fetchFromGitHub
, meerk40t-camera
, python3Packages
, gtk3
, wrapGAppsHook3
}:

python3Packages.buildPythonApplication rec {
  pname = "MeerK40t";
  version = "0.9.4000";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meerk40t";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ceDnnHdmJ6VOrM9pSxjeKQ748E8fsIqSQ36qFpXc9Ac=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
  ] ++ (with python3Packages; [
    setuptools
  ]);

  # prevent double wrapping
  dontWrapGApps = true;

  # https://github.com/meerk40t/meerk40t/blob/main/setup.py
  propagatedBuildInputs = with python3Packages; [
    meerk40t-camera
    numpy
    pyserial
    pyusb
    setuptools
    wxpython
  ]
  ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  passthru.optional-dependencies = with python3Packages; {
    cam = [
      opencv4
    ];
    camhead = [
      opencv4
    ];
    dxf = [
      ezdxf
    ];
    gui = [
      wxpython
      pillow
      opencv4
      ezdxf
    ];
  };

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  nativeCheckInputs = with python3Packages; [
    unittestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    changelog = "https://github.com/meerk40t/meerk40t/releases/tag/${version}";
    description = "MeerK40t LaserCutter Software";
    mainProgram = "meerk40t";
    homepage = "https://github.com/meerk40t/meerk40t";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
