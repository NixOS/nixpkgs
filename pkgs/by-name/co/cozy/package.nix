{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  gobject-introspection,
  libadwaita,
  gst_all_1,
}:

python3Packages.buildPythonApplication rec {
  pname = "cozy";
  version = "1.3.0";
  pyproject = false; # built with meson

  src = fetchFromGitHub {
    owner = "geigi";
    repo = "cozy";
    tag = version;
    hash = "sha256-oMgdz2dny0u1XV13aHu5s8/pcAz8z/SAOf4hbCDsdjw";
  };

  # FIX: The "Support Debian non-standard python paths" resolves to store path of python
  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
        'from distutils.sysconfig import get_python_lib; print(get_python_lib(prefix=""))' \
        "print(\"$out/${python3Packages.python.sitePackages}\")"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    libadwaita
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-base
    gst-plugins-bad
  ]);

  propagatedBuildInputs = with python3Packages; [
    distro
    mutagen
    peewee
    pygobject3
    pytz
    requests
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    ln -s $out/bin/com.github.geigi.cozy $out/bin/cozy
  '';

  meta = with lib; {
    description = "Modern audio book player for Linux";
    homepage = "https://cozy.geigi.de/";
    maintainers = with maintainers; [
      makefu
      aleksana
    ];
    license = licenses.gpl3Plus;
    mainProgram = "com.github.geigi.cozy";
    platforms = platforms.linux;
  };
}
