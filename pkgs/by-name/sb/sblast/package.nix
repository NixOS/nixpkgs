{
  buildGoModule,
  fetchFromGitHub,
  ffmpeg,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  pulseaudio,
  testers,
}:
let
  self = buildGoModule rec {
    pname = "sblast";
    version = "0.7.2";

    src = fetchFromGitHub {
      owner = "ugjka";
      repo = "sblast";
      rev = "v${version}";
      hash = "sha256-ICSnLfzBoaax3YKa4LiTBQ4zxgDxttxcN4YVLApFH24=";
    };

    vendorHash = "sha256-yPwLilMiDR1aSeuk8AEmuYPsHPRWqiByGLwgkdI5t+s=";

    nativeBuildInputs = [
      makeBinaryWrapper
    ];

    postInstall = ''
      wrapProgram $out/bin/sblast \
          --suffix PATH : ${
            lib.makeBinPath [
              ffmpeg
              pulseaudio
            ]
          }
    '';

    # build only the toplevel package, and not `makerel`
    subPackages = ".";

    passthru = {
      updateScript = nix-update-script { };
      tests.version = testers.testVersion {
        package = self;
        version = "v${version}";
      };
    };

    meta = {
      description = "Blast your Linux audio to DLNA receivers";
      homepage = "https://github.com/ugjka/sblast";
      license = lib.licenses.mit;
      mainProgram = "sblast";
      maintainers = with lib.maintainers; [ colinsane ];
      platforms = lib.platforms.linux;
    };
  };
in
self
