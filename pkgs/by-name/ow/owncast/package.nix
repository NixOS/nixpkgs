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
  version = "0.2.0";
in
buildGoModule {
  pname = "owncast";
  inherit version;
  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    hash = "sha256-MdquhDdbOdP1shnKHBlzQrSDe41fp0qnMzgaqL89jTk=";
  };
  vendorHash = "sha256-ERilQZ8vnhGW1IEcLA4CcmozDooHKbnmASMw87tjYD4=";

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

  meta = with lib; {
    description = "self-hosted video live streaming solution";
    homepage = "https://owncast.online";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ MayNiklas ];
    mainProgram = "owncast";
  };

}
