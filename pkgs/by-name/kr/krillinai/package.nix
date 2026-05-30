{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libxxf86vm,
  libxrandr,
  libxi,
  libxinerama,
  libxcursor,
  libx11,
  libGL,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "krillinai";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "krillinai";
    repo = "KlicStudio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CMeF24BCJ+wbiXCl0iJm0acNoggVxeOu3Q/cXJY8aQo=";
  };

  vendorHash = "sha256-bAKLNpt0K06egScyn7ImHV0csDsMQGUm92kU1PVQK+I=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxinerama
    libxxf86vm
    libxcursor
    libxrandr
    libx11
    libxi
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
    maintainers = [ ];
  };
})
