{
  lib,
  stdenv,
  fetchFromGitHub,
  pipewire,
  cmake,
  extra-cmake-modules,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pipecontrol";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "portaloffreedom";
    repo = "pipecontrol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WvQFmoEaxnkI61wPldSnMAoPAxNtI399hdHb/9bkPqc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];

  buildInputs = [
    pipewire
  ]
  ++ (with libsForQt5; [
    qtbase
    kirigami2
    kcoreaddons
    ki18n
    qtquickcontrols2
  ]);

  meta = {
    description = "Pipewire control GUI program in Qt (Kirigami2)";
    mainProgram = "pipecontrol";
    homepage = "https://github.com/portaloffreedom/pipecontrol";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tilcreator ];
  };
})
