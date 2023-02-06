{ lib
, stdenv
, fetchFromGitHub
, qtbase
, qmake
, wrapQtAppsHook
, wireshark-cli
}:


stdenv.mkDerivation {
  pname = "qtwirediff";
  version = "unstable-2023-03-07";

  src = fetchFromGitHub {
    owner = "aaptel";
    repo = "qtwirediff";
    rev = "e0a38180cdf9d94b7535c441487dcefb3a8ec72e";
    hash = "sha256-QS4PslSHe2qhxayF7IHvtFASgd4A7vVtSY8tFQ6dqXM=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 -T qtwirediff $out/bin/qtwirediff
    wrapProgram $out/bin/qtwirediff \
      --prefix PATH : "${lib.makeBinPath [ wireshark-cli ]}"
    runHook postInstall
  '';

  meta = {
    description = "Debugging tool to diff network traffic leveraging Wireshark";
    homepage = "https://github.com/aaptel/qtwirediff";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ janik ];
  };
}
