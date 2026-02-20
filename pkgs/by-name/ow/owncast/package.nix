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
  version = "0.2.4";
in
buildGoModule {
  pname = "owncast";
  inherit version;

  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    tag = "v${version}";
    hash = "sha256-euqmAsGLh7enMbRKeGS7pB3L+12uAHFM2mqahst/bww=";
  };

  patches = [
    ./fix-go.sum.diff
  ];

  vendorHash = "sha256-XQXv1XeedHQozB56+boi32jsXQoCtD2XIg3deDvXIfw=";

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
