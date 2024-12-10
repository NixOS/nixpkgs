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

python3Packages.buildPythonApplication rec {
  pname = "bleachbit";
  version = "4.4.0";

  format = "other";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "0kqqfzq6bh03n7kxb9vd483bqi1cklfvj35a7h4iqk96sq1xv8z6";
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

  meta = with lib; {
    homepage = "http://bleachbit.sourceforge.net";
    description = "A program to clean your computer";
    longDescription = "BleachBit helps you easily clean your computer to free space and maintain privacy.";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      leonardoce
      mbprtpmnr
    ];
    mainProgram = "bleachbit";
  };
}
