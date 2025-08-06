{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  makeDesktopItem,
  copyDesktopItems,
  desktopToDarwinBundle,
  enableModern ? true,
}:

python3Packages.buildPythonApplication rec {
  pname = "ausweiskopie";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Varbin";
    repo = "ausweiskopie";
    tag = "v${version}";
    hash = "sha256-axy/cI5n2uvMKZ2Fkb0seFMRBKv6rpU01kgKSiQ10jE=";
  };

  nativeBuildInputs = [
    copyDesktopItems
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Meine Ausweiskopie";
      exec = "ausweiskopie";
      icon = "ausweiskopie";
      desktopName = "Meine Ausweiskopie";
      comment = "Create redacted copies of German identity cards";
      categories = [
        "Office"
        "Viewer"
      ];
    })
  ];

  dependencies =
    with python3Packages;
    (
      [
        pillow
        tkinter
        importlib-resources
      ]
      ++ lib.optionals enableModern optional-dependencies.modern
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        dbus-next
        pygobject3
      ]
    );

  optional-dependencies.modern = [ python3Packages.ttkbootstrap ];

  postInstall = ''
    install -Dm644 ./src/ausweiskopie/resources/icon_colored.png $out/share/icons/hicolor/256x256/apps/ausweiskopie.png
  '';

  meta = {
    description = "Create privacy friendly and legal copies of your Ausweisdokument";
    homepage = "https://github.com/Varbin/ausweiskopie";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ e1mo ];
    platforms = lib.platforms.unix;
    mainProgram = "ausweiskopie";
  };
}
