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
  version = "0.2.5";
in
buildGoModule {
  pname = "owncast";
  inherit version;

  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    tag = "v${version}";
    hash = "sha256-REgo9RC1izb9vJ6ae66Wti9yfP8DrCGetf6O4rX3DPY=";
  };

  vendorHash = "sha256-T4nr4lNUEq6grZ21qumaOjIDIDoJK7Ql8j8WbCy2u3g=n";

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
