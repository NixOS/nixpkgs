{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  xorg,
  freetype,
  fontconfig,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxwm";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "tonybanters";
    repo = "oxwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-URPMyuAAumlZo01nbZFdpNA1bfRHjM8W/4ySbDnRTQ0=";
  };

  cargoHash = "sha256-d0+B2LbNF2QYPRjaL7YjFWKXwLUQGAU1z43MU7Plw4Y=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorg.libX11
    xorg.libXft
    xorg.libXrender
    freetype
    fontconfig
  ];

  # tests require a running X server
  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = ''
    install -Dm644 resources/oxwm.desktop -t $out/share/xsessions
    install -Dm644 resources/oxwm.1 -t $out/share/man/man1
    install -Dm644 templates/oxwm.lua -t $out/share/oxwm
  '';

  passthru.providedSessions = [ "oxwm" ];

  meta = {
    description = "Dynamic window manager written in Rust, inspired by dwm";
    homepage = "https://github.com/tonybanters/oxwm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tonybanters ];
    platforms = lib.platforms.linux;
    mainProgram = "oxwm";
  };
})
