{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, bluez
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rofi-bluetooth";
  version = "unstable-2023-02-03";

  src = fetchFromGitHub {
    owner = "nickclyde";
    repo = finalAttrs.pname;
    # https://github.com/nickclyde/rofi-bluetooth/issues/19
    rev = "9d91c048ff129819f4c6e9e48a17bd54343bbffb";
    sha256 = "sha256-1Xe3QFThIvJDCUznDP5ZBzwZEMuqmxpDIV+BcVvQDG8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D --target-directory=$out/bin/ ./rofi-bluetooth

    wrapProgram $out/bin/rofi-bluetooth \
      --prefix PATH ":" ${lib.makeBinPath [ bluez ] }

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
})
