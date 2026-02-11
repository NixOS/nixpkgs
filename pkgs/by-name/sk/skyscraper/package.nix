{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  mdbtools,
  p7zip,
  python3,
  sqlite,
  installShellFiles,

  # Whether to compile with XDG support
  # (See: https://gemba.github.io/skyscraper/XDG/)
  enableXdg ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skyscraper";
  version = "3.18.4";

  src = fetchFromGitHub {
    owner = "Gemba";
    repo = "skyscraper";
    tag = finalAttrs.version;
    hash = "sha256-JuV8BpA9WHalw+riS4qpc+pRAe45hr673YpsPJNAB+A=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qmake
    installShellFiles
  ];

  buildInputs = [
    qt6.qtbase
    mdbtools
    sqlite
    python3
  ];

  postPatch = lib.optionalString enableXdg ''
    substituteInPlace skyscraper.pro --replace-fail "#DEFINES+=XDG" "DEFINES+=XDG"
  '';

  postInstall = ''
    installShellCompletion --cmd Skyscraper \
      --bash supplementary/bash-completion/Skyscraper.bash
  '';

  preFixup = ''
    qtWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ p7zip ]})
    chmod +x $out/bin/*.py
    sed -i '2i\\export PATH="${
      lib.makeBinPath [
        mdbtools
        sqlite
      ]
    }:$PATH"' \
      $out/bin/mdb2sqlite.sh
  '';

  env.PREFIX = placeholder "out";

  meta = {
    description = "Powerful and versatile game data scraper written in Qt and C++";
    homepage = "https://gemba.github.io/skyscraper/";
    downloadPage = "https://github.com/Gemba/skyscraper/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ashgoldofficial ];
    mainProgram = "Skyscraper";
    platforms = lib.platforms.linux;
  };
})
