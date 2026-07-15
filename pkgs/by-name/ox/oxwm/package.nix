{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  zig_0_16,
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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "tonybanters";
    repo = "oxwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N0uKA51AR0YFUcp6MdIiJS5HtHobSaDdXPRrMEOCSEM=";
  };

  deps = callPackage ./build.zig.zon.nix { };

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
  ];

  nativeBuildInputs = [
    zig_0_16.hook
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
