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
    version = "0.7.0";

    src = fetchFromGitHub {
      owner = "ugjka";
      repo = "sblast";
      rev = "v${version}";
      hash = "sha256-+ZeZ2lohAngfljCa/z9yjCKvQwCMEiwzzPFrpAU8lWA=";
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

    meta = with lib; {
      description = "Blast your Linux audio to DLNA receivers";
      homepage = "https://github.com/ugjka/sblast";
      # license is "MIT+NoAI": <https://github.com/ugjka/sblast/blob/main/LICENSE>
      license = licenses.unfree;
      mainProgram = "sblast";
      maintainers = with maintainers; [ colinsane ];
      platforms = platforms.linux;
    };
  };
in
self
