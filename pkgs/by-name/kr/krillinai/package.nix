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
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "krillinai";
    repo = "KlicStudio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cd+MrKXezcBKRSwmoRaD/2jiNT7r8R7IGweXHDZFhWE=";
  };

  vendorHash = "sha256-bAKLNpt0K06egScyn7ImHV0csDsMQGUm92kU1PVQK+I=";

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
    homepage = "https://github.com/krillinai/KlicStudio";
    changelog = "https://github.com/krillinai/KlicStudio/releases/tag/v${finalAttrs.version}";
    mainProgram = "krillinai-desktop";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
})
