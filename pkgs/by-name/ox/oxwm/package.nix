{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libx11,
  libxft,
  libxrender,
  freetype,
  fontconfig,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxwm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "tonybanters";
    repo = "oxwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zVYYRGe5ZIR1AJgKZi9s403NKM7hKAqhEbNWYSkgpT0=";
  };

  cargoHash = "sha256-Rs8eGR8WY7qOPM0rfu6lTNDl6TVMR+rrIc6Ub+M7vfs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxft
    libxrender
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
