{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  alsa-lib,
}:

buildGoModule rec {
  pname = "jellycli";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tryffel";
    repo = "jellycli";
    rev = "v${version}";
    sha256 = "1awzcxnf175a794rhzbmqxxjss77mfa1yrr0wgdxaivrlkibxjys";
  };

  vendorHash = "sha256-3tmNZd1FH1D/1w4gRmaul2epKb70phSUAjUBCbPV3Ak=";

  patches = [
    # Fixes log file path for tests.
    ./fix-test-dir.patch
  ];

  buildInputs = [ alsa-lib ];

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Jellyfin terminal client";
    longDescription = ''
      Terminal music player, works with Jellyfin (>= 10.6) , Emby (>= 4.4), and
      Subsonic comptabile servers (API >= 1.16), e.g., Navidrome.
    '';
    homepage = "https://github.com/tryffel/jellycli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ oxzi ];
    mainProgram = "jellycli";
  };
}
