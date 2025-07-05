{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  bc,
  bluez,
}:

stdenv.mkDerivation {
  pname = "rofi-bluetooth";
  version = "0-unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "nickclyde";
    repo = "rofi-bluetooth";
    # https://github.com/nickclyde/rofi-bluetooth/issues/19
    rev = "0cca4d4aa1c82c9373ce5da781d73683a29484c6";
    sha256 = "sha256-ggYoCWRuCi1WKcwb+0zVwq3WvSqJQBitI+/XTpOc6uw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-bluetooth

    wrapProgram $out/bin/rofi-bluetooth \
      --prefix PATH ":" ${
        lib.makeBinPath [
          bc
          bluez
        ]
      }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rofi-based interface to connect to bluetooth devices and display status info";
    homepage = "https://github.com/nickclyde/rofi-bluetooth";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ MoritzBoehme ];
    mainProgram = "rofi-bluetooth";
    platforms = platforms.linux;
  };
}
