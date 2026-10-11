{
  autoPatchelfHook,
  dbus,
  fetchurl,
  fontconfig,
  freetype,
  lib,
  libglvnd,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  nix-update-script,
  stdenv,
  wayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "con-terminal";
  version = "0.1.0-beta.111";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/nowledge-co/con-terminal/releases/download/v${finalAttrs.version}/con-${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-NjO91Rb3EhVv9Xpea8fJP4krV6ElP6ps0et01X8DgdA=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    dbus
    fontconfig
    freetype
    libglvnd
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    stdenv.cc.cc.lib
    wayland
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 con "$out/bin/con"
    install -Dm755 con-cli "$out/bin/con-cli"
    install -Dm644 co.nowledge.con.png "$out/share/icons/hicolor/256x256/apps/co.nowledge.con.png"
    install -Dm644 co.nowledge.con.desktop "$out/share/applications/co.nowledge.con.desktop"
    substituteInPlace "$out/share/applications/co.nowledge.con.desktop" \
      --replace-fail 'Exec=/usr/local/bin/con' "Exec=$out/bin/con"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "GPU-accelerated terminal emulator with a built-in AI agent harness";
    homepage = "https://github.com/nowledge-co/con-terminal";
    changelog = "https://github.com/nowledge-co/con-terminal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ign1x ];
    mainProgram = "con";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
