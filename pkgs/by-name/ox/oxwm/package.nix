{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  pkg-config,
  libx11,
  libxft,
  libxinerama,
  lua5_4,
  freetype,
  fontconfig,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oxwm";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "tonybanters";
    repo = "oxwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W6muqajSk9UR646ZmLkx/wWfiaWLo+d1lJMiLm82NC8=";
  };

  nativeBuildInputs = [
    zig.hook
    pkg-config
  ];

  buildInputs = [
    libx11
    libxft
    libxinerama
    lua5_4
    freetype
    fontconfig
  ];

  # tests require a running X server
  doCheck = false;

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    install -Dm644 resources/oxwm.desktop -t $out/share/xsessions
    install -Dm644 resources/oxwm.1 -t $out/share/man/man1
    install -Dm644 templates/oxwm.lua -t $out/share/oxwm
  '';

  passthru.providedSessions = [ "oxwm" ];

  meta = {
    description = "Dynamic window manager written in Zig, inspired by dwm";
    homepage = "https://github.com/tonybanters/oxwm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tonybanters ];
    platforms = lib.platforms.linux;
    mainProgram = "oxwm";
  };
})
