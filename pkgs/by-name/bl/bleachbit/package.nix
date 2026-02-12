{
  lib,
  python3Packages,
  fetchurl,
  gettext,
  gobject-introspection,
  wrapGAppsHook3,
  glib,
  gtk3,
  libnotify,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bleachbit";
  version = "5.0.0";

  pyproject = false;

  src = fetchurl {
    url = "mirror://sourceforge/bleachbit/bleachbit-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-CU5IW8NVWuPl4PHu6mYpD5mOpRiDq6oZk9pDmuz8PjA=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libnotify
  ];

  propagatedBuildInputs = with python3Packages; [
    chardet
    pygobject3
    requests
  ];

  # Patch the many hardcoded uses of /usr/share/ and /usr/bin
  postPatch = ''
    find -type f -exec sed -i -e 's@/usr/share@${placeholder "out"}/share@g' {} \;
    find -type f -exec sed -i -e 's@/usr/bin@${placeholder "out"}/bin@g' {} \;
    find -type f -exec sed -i -e 's@${placeholder "out"}/bin/python3@${python3Packages.python}/bin/python3@' {} \;
  '';

  dontBuild = true;

  installFlags = [
    "prefix=${placeholder "out"}"
  ];

  # Prevent double wrapping from wrapGApps and wrapPythonProgram
  dontWrapGApps = true;
  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
  ];

  strictDeps = false;

  meta = {
    homepage = "https://bleachbit.sourceforge.net";
    description = "Program to clean your computer";
    longDescription = "BleachBit helps you easily clean your computer to free space and maintain privacy.";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      leonardoce
      mbprtpmnr
    ];
    mainProgram = "bleachbit";
  };
})
