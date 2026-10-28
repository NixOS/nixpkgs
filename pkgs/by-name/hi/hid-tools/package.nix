{
  python3Packages,
  lib,
  fetchFromGitLab,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "hid-tools";
  version = "0.12";

  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libevdev";
    repo = "hid-tools";
    tag = finalAttrs.version;
    hash = "sha256-00Vsnjio8LEcuCfvNVEbFpJ2JabmMZqwXli1My5SVWs=";
  };

  build-system = with python3Packages; [
    hatchling
    pypandoc
  ];

  dependencies = with python3Packages; [
    libevdev
    parse
    pyyaml
    click
    pyroute2
    pyudev
    typing-extensions
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  # Tests require /dev/uhid
  # https://gitlab.freedesktop.org/libevdev/hid-tools/-/issues/18#note_166353
  doCheck = false;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pypandoc_binary" "pypandoc"
  '';

  meta = {
    description = "Python scripts to manipulate HID data";
    homepage = "https://gitlab.freedesktop.org/libevdev/hid-tools";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.freedesktop ];
  };
})
