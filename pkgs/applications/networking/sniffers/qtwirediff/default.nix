{ lib
, stdenv
, fetchFromGitHub
, qtbase
, qmake
, qtwayland
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
  ] ++ lib.optionals stdenv.isLinux [
    qtwayland
  ];

  installPhase = ''
    runHook preInstall
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    cp -r qtwirediff.app $out/Applications
    makeWrapper $out/{Applications/qtwirediff.app/Contents/MacOS,bin}/qtwirediff
  '' + lib.optionalString stdenv.isLinux ''
    install -Dm755 -T qtwirediff $out/bin/qtwirediff
    wrapProgram $out/bin/qtwirediff \
      --prefix PATH : "${lib.makeBinPath [ wireshark-cli ]}"
  '' + ''
    runHook postInstall
  '';

  meta = {
    description = "Debugging tool to diff network traffic leveraging Wireshark";
    mainProgram = "qtwirediff";
    homepage = "https://github.com/aaptel/qtwirediff";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
