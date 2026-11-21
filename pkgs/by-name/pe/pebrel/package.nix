{
  autoPatchelfHook,
  dpkg,
  fetchurl,
  lib,
  libglvnd,
  libxcb,
  libxkbcommon,
  nix-update-script,
  stdenv,
  wayland,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pebrel";
  version = "1.9.1";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/Kuddev/pebrel/releases/download/v${finalAttrs.version}/Pebrel-v${finalAttrs.version}-linux-x64-preview.deb";
    hash = "sha256-KNwBXCQx+rOSKQivJ4S/QKqoqSJAFzCWJ9kVT5yOg30=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];
  buildInputs = [
    libglvnd
    libxcb
    libxkbcommon
    stdenv.cc.cc.lib
    wayland
  ];

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    dpkg-deb -x "$src" "$out"
    mv "$out/usr/bin" "$out/bin"
    mv "$out/usr/share" "$out/share"
    rmdir "$out/usr"
    substituteInPlace "$out/share/applications/io.github.kuddev.pebrel.desktop" \
      --replace-fail 'Exec=pebrel' "Exec=$out/bin/pebrel"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--use-github-releases" ];
  };

  meta = {
    description = "GPU-accelerated terminal for local and remote workflows";
    homepage = "https://github.com/Kuddev/pebrel";
    changelog = "https://github.com/Kuddev/pebrel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ign1x ];
    mainProgram = "pebrel";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
