{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  xorg,
  libGL,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "krillinai";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "krillinai";
    repo = "KrillinAI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jQlgkpQ+UTzn6MqGa+yVQ9v04IGGlMQQim3s0Oc9Zts=";
  };

  vendorHash = "sha256-mpvypCZmvVVljftGpcV1aea3s7Xmhr0jLfKZIZ0nkX8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libXinerama
    xorg.libXxf86vm
    xorg.libXcursor
    xorg.libXrandr
    xorg.libX11
    xorg.libXi
    libGL
  ];

  # open g:\bin\AI\tasks\gdQRrtQP\srt_no_ts_1.srt: no such file or directory
  doCheck = false;

  postInstall = ''
    mv $out/bin/desktop $out/bin/krillinai-desktop
    mv $out/bin/server $out/bin/krillinai-server
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Video translation and dubbing tool";
    homepage = "https://github.com/krillinai/KrillinAI";
    changelog = "https://github.com/krillinai/KrillinAI/releases/tag/v${finalAttrs.version}";
    mainProgram = "krillinai-desktop";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ emaryn ];
  };
})
