{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  bash,
  which,
  ffmpeg,
  makeBinaryWrapper,
}:
let
  version = "0.3.0";
in
buildGoModule {
  pname = "owncast";
  inherit version;

  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    tag = "v${version}";
    hash = "sha256-Nfpd45pt4XKG8iAliqLIw3kzGDWs0qNeMTiEkctWoY0=";
  };

  vendorHash = "sha256-yl1jCJmTrW42/BpCsgxO3lTBat9HBMCXf0qnF0npT7Y=";

  subPackages = [ "." ];

  propagatedBuildInputs = [ ffmpeg ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/owncast \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          which
          ffmpeg
        ]
      }
  '';

  installCheckPhase = ''
    runHook preCheck
    $out/bin/owncast --help
    runHook postCheck
  '';

  passthru.tests.owncast = nixosTests.owncast;

  meta = {
    description = "Self-hosted video live streaming solution";
    homepage = "https://owncast.online";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      flexiondotorg
      MayNiklas
    ];
    mainProgram = "owncast";
  };
}
