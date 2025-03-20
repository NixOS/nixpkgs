{
  autoconf,
  cmake,
  dbus,
  fetchFromGitHub,
  ffmpeg,
  git,
  gst_all_1,
  lib,
  libdrm,
  libtool,
  libva,
  libxkbcommon,
  makeWrapper,
  nix-update-script,
  pango,
  pipewire,
  pkg-config,
  rustPlatform,
  stdenv,
  typescript,
  versionCheckHook,
  xorg,
  x264,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weylus";
  version = "0.11.4-unstable-2025-02-24";

  src = fetchFromGitHub {
    owner = "H-M-H";
    repo = "Weylus";
    rev = "5202806798ccca67c24da52ba51ee50b973b7089";
    hash = "sha256-lx1ZVp5DkQiL9/vw6PAZ34Lge+K8dfEVh6vLnCUNf7M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dLhlYOrLjoBSRGDJB0qTEIb+oGnp9X+ADHddpYITdl8=";

  nativeBuildInputs = [
    autoconf
    cmake
    git
    libtool
    makeWrapper
    pkg-config
    typescript
  ];

  buildInputs =
    [
      ffmpeg
      x264
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      dbus
      gst_all_1.gst-plugins-base
      libdrm
      libva
      libxkbcommon
      pango
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXext
      xorg.libXfixes
      xorg.libXft
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libXv
      wayland
    ];

  cargoBuildFlags = [ "--features=ffmpeg-system" ];
  cargoTestFlags = [ "--features=ffmpeg-system" ];

  postUnpack = ''
    substituteInPlace source/Cargo.toml --replace-fail "version = \"0.11.4\"" "version = \"${finalAttrs.version}\""
  '';

  postFixup =
    let
      GST_PLUGIN_PATH = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
        gst_all_1.gst-plugins-base
        pipewire
      ];
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/weylus --prefix GST_PLUGIN_PATH : ${GST_PLUGIN_PATH}
    '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -vDm755 weylus.desktop $out/share/applications/weylus.desktop
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Use your tablet as graphic tablet/touch screen on your computer";
    homepage = "https://github.com/H-M-H/Weylus";
    license = with lib.licenses; [ agpl3Only ];
    mainProgram = "weylus";
    maintainers = with lib.maintainers; [ lom ];
    platforms = lib.platforms.unix;
  };
})
