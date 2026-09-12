{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  clang,
  makeWrapper,
  ffmpeg,
  libdrm,
  libgbm,
  libva,
  libxkbcommon,
  mesa,
  pipewire,
  pulseaudio,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hypr-rdp";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "MuNeNICK";
    repo = "hypr-rdp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yrC8fITJofWJ2wpZMiaX06UVCMFI4GRg9pGyaTdosHg=";
  };

  cargoHash = "sha256-fx2SA0xXlxDIBI/2EtvzW9LGK1pbAZevK0y/dJAw2vg=";

  nativeBuildInputs = [
    pkg-config
    cmake
    clang
    makeWrapper
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg
    libdrm
    libgbm
    libva
    libxkbcommon
    mesa
    pipewire
    wayland
  ];

  # pulseaudio is a runtime lookup, not a link-time dependency: audio is
  # forwarded by shelling out to PulseAudio tools, so it belongs in the
  # wrapper rather than in buildInputs.
  postInstall = ''
    wrapProgram $out/bin/hypr-rdp \
      --prefix PATH : ${lib.makeBinPath [ pulseaudio ]}
  '';

  # Upstream's own package.nix sets doCheck = false: the tests want a live
  # Wayland compositor and a VAAPI device, neither of which exists in the
  # build sandbox.
  doCheck = false;

  meta = {
    description = "RDP server for Hyprland and other wlroots compositors";
    homepage = "https://github.com/MuNeNICK/hypr-rdp";
    changelog = "https://github.com/MuNeNICK/hypr-rdp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "hypr-rdp";
    maintainers = with lib.maintainers; [ olafkfreund ];
    platforms = lib.platforms.linux;
  };
})
