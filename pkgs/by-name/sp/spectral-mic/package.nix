{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  makeWrapper,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  fontconfig,
  pipewire,
  versionCheckHook,
}:
let
  # Loaded via dlopen at runtime by winit (x11-dl, xkbcommon-dl) and
  # wayland-sys; everything linked at build time (fontconfig, pipewire)
  # resolves through the binary's RUNPATH instead.
  dlopenLibs = [
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spectral-mic";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mmc";
    repo = "spectral";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2HaTOLhHVLYKnEsWjvLf1GqPvtBdrjotG1kZj9mbwkk=";
  };

  cargoHash = "sha256-OMrYfPQim9H178LnRUg2Ues9Nf2txz4u+tEddrllKME=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    fontconfig
    pipewire
  ];

  postInstall = ''
    install -Dm644 assets/page.codeberg.mmc.Spectral.desktop $out/share/applications/page.codeberg.mmc.Spectral.desktop
    install -Dm644 assets/page.codeberg.mmc.Spectral.metainfo.xml $out/share/metainfo/page.codeberg.mmc.Spectral.metainfo.xml
    install -Dm644 assets/spectral.png $out/share/icons/hicolor/512x512/apps/page.codeberg.mmc.Spectral.png
    install -Dm644 THIRD-PARTY.md $out/share/licenses/spectral-mic/THIRD-PARTY.md

    wrapProgram $out/bin/spectral \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath dlopenLibs}"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Real-time audio noise suppression application";
    longDescription = ''
      Spectral is a real-time audio noise suppression application powered by
      RNNoise, a hybrid DSP and neural-network-based noise suppression system.
      It creates a virtual microphone that can be used with any application,
      filtering out background noise in real-time.
    '';
    homepage = "https://codeberg.org/mmc/spectral";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.mmclinton ];
    mainProgram = "spectral";
    platforms = lib.platforms.linux;
  };
})
