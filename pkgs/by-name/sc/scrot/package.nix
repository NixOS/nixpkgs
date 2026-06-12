{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  autoreconfHook,
  autoconf-archive,
  libx11,
  libxext,
  libxfixes,
  libxcomposite,
  libxinerama,
  pkg-config,
  libbsd,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scrot";
  version = "1.12.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "scrot";
    tag = finalAttrs.version;
    hash = "sha256-ExZH+bjpEvdbSYM8OhV+cyn4j+0YrHp5/b+HsHKAHCA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    imlib2
    libx11
    libxext
    libxfixes
    libxcomposite
    libxinerama
    libbsd
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "Command-line screen capture utility";
    mainProgram = "scrot";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    license = lib.licenses.mitAdvertising;
    hasNoMaintainersButDependents = true;
  };
})
