{
  buildGoModule,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  pulseaudio,
}:
buildGoModule rec {
  pname = "blast-ugjka";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ugjka";
    repo = "blast";
    rev = "v${version}";
    hash = "sha256-yMwMG0y2ehq2dBMlv9hF+i0TgmMjW3ojBVGiqEUSrhU=";
  };

  vendorHash = "sha256-yPwLilMiDR1aSeuk8AEmuYPsHPRWqiByGLwgkdI5t+s=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/blast \
        --suffix PATH : ${lib.makeBinPath [ pulseaudio ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "blast your linux audio to DLNA receivers";
    # license is "MIT+NoAI": <https://github.com/ugjka/blast/blob/main/LICENSE>
    license = licenses.unfree;
    homepage = "https://github.com/ugjka/blast";
    maintainers = with maintainers; [ colinsane ];
    platforms = platforms.linux;
  };
}
