{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  wayland,
  libxkbcommon,
  libGL,
  fontconfig,
  versionCheckHook,
  nix-update-script,
}:

let
  runtimeLibs = [
    wayland
    libxkbcommon
    libGL
    fontconfig
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jotty";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "justanoobcoder";
    repo = "jotty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sb4uojuamrFVeK+xJTocKL8fvam+F+ziG4/Xa9wposc=";
  };

  cargoHash = "sha256-KCJozFVPzm0w+mQhZ2CUwX2sdHP2pakTR0S3MPAsUE4=";

  outputs = [
    "out"
    "terminfo"
  ];

  nativeBuildInputs = [
    pkg-config
    ncurses
  ];

  buildInputs = runtimeLibs;

  propagatedUserEnvPkgs = [ (placeholder "terminfo") ];

  postInstall = ''
    install -Dm644 extra/jotty.desktop -t $out/share/applications
    install -Dm644 extra/jotty.svg -t $out/share/icons/hicolor/scalable/apps

    mkdir -p $terminfo/share/terminfo
    tic -x -o $terminfo/share/terminfo extra/jotty.terminfo
    ln -s $terminfo/share/terminfo $out/share/terminfo
  '';

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeLibs} $out/bin/jotty
  '';

  __structuredAttrs = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland-native terminal emulator";
    homepage = "https://github.com/justanoobcoder/jotty";
    changelog = "https://github.com/justanoobcoder/jotty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ justanoobcoder ];
    mainProgram = "jotty";
    platforms = lib.platforms.linux;
  };
})
