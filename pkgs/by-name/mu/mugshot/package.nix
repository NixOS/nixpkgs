{
  coreutils,
  fetchFromGitHub,
  gtk3,
  intltool,
  lib,
  python3Packages,
  shadow,
  wrapGAppsHook3,
}:
python3Packages.buildPythonApplication {
  pname = "mugshot";
  version = "0.4.3";

  pyproject = true;

  build-system = with python3Packages; [
    setuptools
  ];

  src = fetchFromGitHub {
    owner = "bluesabre";
    repo = "mugshot";
    rev = "mugshot-0.4.3";
    hash = "sha256-RjD7IUBHqmB4DJ1abATYDPZLIHVwiXblWvWcq6xjhQk=";
  };

  dependencies = with python3Packages; [
    dbus-python
    distutils
    distutils-extra
    pexpect
    pycairo
    pygobject3
  ];

  buildInputs = [
    gtk3
  ];

  nativeBuildInputs = [
    intltool
    wrapGAppsHook3
  ];

  postPatch = ''
    # ensure `true`
    substituteInPlace mugshot_lib/SudoDialog.py \
      --replace-fail "['/bin/true']" \
                     "['${coreutils}/bin/true']"

    # ensure `chfn`
    substituteInPlace mugshot/MugshotWindow.py \
      --replace-fail "chfn = which('chfn')" \
                     "chfn = '${shadow}/bin/chfn'"

    # permission for `chfn`
    substituteInPlace mugshot/MugshotWindow.py \
      --replace-fail "command = \"%s -h \\\"%s\\\" %s\" % (chfn, home_phone, username)" \
                     "command = \"%s %s -h \\\"%s\\\" %s\" % (sudo, chfn, home_phone, username)" \
      --replace-fail "p_command = \"%s -p \\\"%s\\\" %s\" % (chfn, office_phone, username)" \
                     "p_command = \"%s %s -p \\\"%s\\\" %s\" % (sudo, chfn, office_phone, username)" \
      --replace-fail "w_command = \"%s -w \\\"%s\\\" %s\" % (chfn, office_phone, username)" \
                     "w_command = \"%s %s -w \\\"%s\\\" %s\" % (sudo, chfn, office_phone, username)"
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  postFixup = ''
    # after installPhase, `__mugshot_data_directory__` will incorrectly refer to an outer store, and unable to find the data files
    substituteInPlace $out/${python3Packages.python.sitePackages}/mugshot_lib/mugshotconfig.py \
      --replace-fail "__mugshot_data_directory__ = " \
                     "__mugshot_data_directory__ = '$out/share/mugshot/' # patched: "
  '';

  meta = {
    description = "User management utility for Linux";
    homepage = "https://github.com/bluesabre/mugshot";
    license = lib.licenses.gpl3;
    mainProgram = "mugshot";
    maintainers = [ ];
    platform = lib.platfroms.linux;
  };
}
