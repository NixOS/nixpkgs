{
  stdenv,
  lib,
  python3Packages,
  gettext,
  qt5,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "dupeguru";
  version = "4.3.1";

  format = "other";

  src = fetchFromGitHub {
    owner = "arsenetar";
    repo = "dupeguru";
    rev = version;
    hash = "sha256-/jkZiCapmCLMp7WfgUmpsR8aNCfb3gBELlMYaC4e7zI=";
  };

  patches = [
    ./remove-setuptools-sandbox.patch
  ];

  nativeBuildInputs = [
    gettext
    python3Packages.pyqt5
    python3Packages.setuptools
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    hsaudiotag3k
    mutagen
    polib
    pyqt5
    pyqt5-sip
    semantic-version
    send2trash
    sphinx
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "NO_VENV=1"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  # Avoid double wrapping Python programs.
  dontWrapQtApps = true;

  # TODO: A bug in python wrapper
  # see https://github.com/NixOS/nixpkgs/pull/75054#discussion_r357656916
  preFixup = ''
    makeWrapperArgs="''${qtWrapperArgs[@]}"
  '';

  # Executable in $out/bin is a symlink to $out/share/dupeguru/run.py
  # so wrapPythonPrograms hook does not handle it automatically.
  postFixup = ''
    wrapPythonProgramsIn "$out/share/dupeguru" "$out $pythonPath"
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "GUI tool to find duplicate files in a system";
    homepage = "https://github.com/arsenetar/dupeguru";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ novoxd ];
    mainProgram = "dupeguru";
  };
}
