{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rofi-unwrapped
, bluez
}:

stdenv.mkDerivation rec {
  pname = "rofi-bluetooth";
  version = "unstable-2021-03-05";

  src = fetchFromGitHub {
    owner = "nickclyde";
    repo = "rofi-bluetooth";
    # https://github.com/nickclyde/rofi-bluetooth/issues/19
    rev = "893db1f2b549e7bc0e9c62e7670314349a29cdf2";
    sha256 = "sha256-3oROJKEQCuSnLfbJ+JSSc9hcmJTPrLHRQJsrUcaOMss=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-bluetooth

    wrapProgram $out/bin/rofi-bluetooth \
      --prefix PATH ":" ${lib.makeBinPath [ rofi-unwrapped bluez ] }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rofi-based interface to connect to bluetooth devices and display status info";
    homepage = "https://github.com/nickclyde/rofi-bluetooth";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ MoritzBoehme ];
    platforms = platforms.linux;
  };
}
