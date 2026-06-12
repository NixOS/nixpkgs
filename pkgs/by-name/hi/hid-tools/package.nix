{
  python3,
  lib,
  fetchFromGitLab,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "hid-tools";
  version = "0.12";

  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libevdev";
    repo = "hid-tools";
    rev = version;
    hash = "sha256-00Vsnjio8LEcuCfvNVEbFpJ2JabmMZqwXli1My5SVWs=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    pypandoc
  ];

  propagatedBuildInputs = with python3.pkgs; [
    libevdev
    parse
    pyyaml
    click
    pyroute2
    pyudev
    typing-extensions
  ];

  nativeCheckInputs = with python3.pkgs; [
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
    license = lib.licenses.mit;
    teams = [ lib.teams.freedesktop ];
  };
}
