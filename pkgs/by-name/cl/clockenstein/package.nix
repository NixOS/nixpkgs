{
  stdenv,
  lib,
  fetchFromGitHub,
  gettext,
  glib,
  glib-networking,
  gobject-introspection,
  gsound,
  gtk3,
  libsecret,
  meson,
  ninja,
  pango,
  python3,
  python3Packages,
  tzdata,
  wrapGAppsHook3,
  xapp,
  xapp-symbolic-icons,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      babel
      caldav
      google-api-python-client
      google-auth-httplib2
      google-auth-oauthlib
      httplib2
      icalendar
      pycairo
      pycurl
      pygobject3
      python-xapp
      requests
      rich
      setproctitle
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clockenstein";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "clockenstein";
    tag = finalAttrs.version;
    hash = "sha256-kR1E6U2PyEEs2MHw4pyo/pJm5QQb6nreeL7qsWadGEw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gettext
    glib
    gobject-introspection
    gtk3
    meson
    ninja
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    glib-networking
    gsound
    gtk3
    libsecret
    pango
    pythonEnv
    xapp
  ];

  postPatch = ''
    substituteInPlace tests/test_store.py --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
    substituteInPlace meson.build --replace-fail "/usr/bin/python3" "python3"
    substituteInPlace data/*.in --replace-quiet "exec /usr/bin/python3" "exec ${pythonEnv.interpreter}"
    substituteInPlace data/clockenstein-{daemon,notification-agent}.desktop.in --replace-fail "/usr/bin/systemctl" "systemctl"
  '';

  doCheck = true;

  preCheck = ''
    export PYTHONPATH="${pythonEnv}/${pythonEnv.sitePackages}:$PYTHONPATH"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "$out/bin"
      --prefix PYTHONPATH : "${pythonEnv}/${pythonEnv.sitePackages}:$out/${pythonEnv.sitePackages}"
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  meta = {
    description = "Calendar application for Linux Desktops";
    homepage = "https://xapp-project.org/clockenstein.html";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers._0david0mp ];
    teams = [ lib.teams.cinnamon ];
    mainProgram = "clockenstein-calendar";
    platforms = lib.platforms.linux;
  };
})
