{
  lib,
  fetchFromGitHub,
  libpulseaudio,
  libnotify,
  gobject-introspection,
  python3Packages,
  unstableGitUpdater,
  fetchpatch2,
  writableTmpDirAsHomeHook,
  extraLibs ? [ ],
}:

python3Packages.buildPythonApplication rec {
  # i3pystatus moved to rolling release:
  # https://github.com/enkore/i3pystatus/issues/584
  version = "3.35-unstable-2025-06-24";
  pname = "i3pystatus";
  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  src = fetchFromGitHub {
    owner = "enkore";
    repo = "i3pystatus";
    rev = "e8e03934d95658c85fa9f594987dac0481ca26c9";
    hash = "sha256-uAt6jxNAUR9txyPtHS4BRtu8Z5QaP6uqFg0sROf356c=";
  };

  patches = [
    # absolutifies the path to the test data in buds test so it can be run from anywhere
    (fetchpatch2 {
      # https://github.com/enkore/i3pystatus/pull/869
      url = "https://github.com/enkore/i3pystatus/commit/7a39c3527566411eb1b3e4f79191839ac4b0424e.patch";
      hash = "sha256-kSf2Nrypw8CCHC7acDkQXI27178HA3NJlyRWkHyYOGs=";
    })
  ];

  nativeBuildInputs = [ gobject-introspection ];

  buildInputs = [
    libpulseaudio
    libnotify
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  checkInputs = [ python3Packages.requests ];

  propagatedBuildInputs =
    with python3Packages;
    [
      keyring
      colour
      netifaces
      psutil
      basiciw
      pygobject3
    ]
    ++ extraLibs;

  makeWrapperArgs = [
    # LC_TIME != C results in locale.Error: unsupported locale setting
    "--set"
    "LC_TIME"
    "C"
    "--suffix"
    "LD_LIBRARY_PATH"
    ":"
    "${lib.makeLibraryPath [ libpulseaudio ]}"
  ];

  postPatch = ''
    makeWrapperArgs+=(--set GI_TYPELIB_PATH "$GI_TYPELIB_PATH")
  '';

  postInstall = ''
    makeWrapper ${python3Packages.python.interpreter} $out/bin/${pname}-python-interpreter \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      ''${makeWrapperArgs[@]}
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    mainProgram = "i3pystatus";
    homepage = "https://github.com/enkore/i3pystatus";
    description = "Complete replacement for i3status";
    longDescription = ''
      i3pystatus is a growing collection of python scripts for status output compatible
      to i3status / i3bar of the i3 window manager.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      igsha
      lucasew
    ];
  };
}
