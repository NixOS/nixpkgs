{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  libnotify,
  wrapGAppsHook3,
  gtk3,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "notifymuch";
  version = "0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kspi";
    repo = "notifymuch";
    # https://github.com/kspi/notifymuch/issues/11
    rev = "9d4aaf54599282ce80643b38195ff501120807f0";
    sha256 = "1lssr7iv43mp5v6nzrfbqlfzx8jcc7m636wlfyhhnd8ydd39n6k4";
  };

  propagatedBuildInputs =
    [
      libnotify
      gtk3
    ]
    ++ (with python3.pkgs; [
      notmuch
      pygobject3
    ]);

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  strictDeps = false;

  meta = with lib; {
    description = "Display desktop notifications for unread mail in a notmuch database";
    mainProgram = "notifymuch";
    homepage = "https://github.com/kspi/notifymuch";
    maintainers = with maintainers; [ arjan-s ];
    license = licenses.gpl3;
  };
}
