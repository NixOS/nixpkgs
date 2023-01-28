{ lib
, asciidoc
, fetchFromGitHub
, gobject-introspection
, gtk3
, installShellFiles
, libappindicator-gtk3
, libnotify
, librsvg
, python3
, udisks2
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "udiskie";
  version = "2.4.2";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    rev = "v${version}";
    hash = "sha256-lQMJVSY3JeZYYOFDyV29Ye2j8r+ngE/ta2wQYipy4hU=";
  };

  patches = [
    ./locale-path.patch
  ];

  postPatch = ''
    substituteInPlace udiskie/locale.py --subst-var out
  '';

  nativeBuildInputs = [
    asciidoc # Man page
    gobject-introspection
    installShellFiles
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  buildInputs = [
    gobject-introspection
    gtk3
    libappindicator-gtk3
    libnotify
    librsvg # SVG icons
    udisks2
  ];

  propagatedBuildInputs = with python3.pkgs; [
    docopt
    keyutils
    pygobject3
    pyyaml
  ];

  postBuild = ''
    make -C doc
  '';

  postInstall = ''
    installManPage doc/udiskie.8
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/coldfix/udiskie";
    changelog = "https://github.com/coldfix/udiskie/blob/${src.rev}/CHANGES.rst";
    description = "Removable disk automounter for udisks";
    longDescription = ''
      udiskie is a udisks2 front-end that allows to manage removeable media such
      as CDs or flash drives from userspace.

      Its features include:
      - automount removable media
      - notifications
      - tray icon
      - command line tools for manual un-/mounting
      - LUKS encrypted devices
      - unlocking with keyfiles (requires udisks 2.6.4)
      - loop devices (mounting iso archives)
      - password caching (requires python keyutils 0.3)
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres dotlambda ];
  };
}
