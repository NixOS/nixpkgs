{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "decoder";
  version = "unstable-2021-11-20";

  src = fetchFromGitHub {
    owner = "PeterPawn";
    repo = "decoder";
    rev = "da0f826629d4e7b873f9d1a39f24c50ff0a68cd2";
    sha256 = "sha256-1sT1/iwtc2ievmLuNuooy9b14pTs1ZC5noDwzFelk7w=";
  };

  patches = [
    # Pull fix pending upstream inclusion for -fno-common toolchains:
    #   https://github.com/PeterPawn/decoder/pull/29
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/PeterPawn/decoder/commit/843ac477c31108023d8008581bf91c5a3acc1859.patch";
      sha256 = "sha256-rRylz8cxgNyPSqL/THdgEBpzcVx1K+xbjUn4PwP9Jn4=";
    })
  ];

  buildInputs = [
    openssl
  ];

  makeFlags = [ "OPENSSL=y" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 src/decoder "$out/bin/decoder"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/PeterPawn/decoder";
    description = ''"secrets" decoding for FRITZ!OS devices'';
    mainProgram = "decoder";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
}
