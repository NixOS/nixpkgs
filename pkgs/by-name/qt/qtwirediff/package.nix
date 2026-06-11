{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  wireshark-cli,
}:

stdenv.mkDerivation {
  pname = "qtwirediff";
  version = "0-unstable-2026-06-10";

  src = fetchFromGitHub {
    owner = "aaptel";
    repo = "qtwirediff";
    rev = "61d7a7013a74ab4ad5fb2c1041d1f2559bd70644";
    hash = "sha256-mE8AiY1KVVLDJyz4yRoVqW2Gae021Ww7u9Qb4EGXetA=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r qtwirediff.app $out/Applications
    makeWrapper $out/{Applications/qtwirediff.app/Contents/MacOS,bin}/qtwirediff
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 -T qtwirediff $out/bin/qtwirediff
    wrapProgram $out/bin/qtwirediff \
      --prefix PATH : "${lib.makeBinPath [ wireshark-cli ]}"
  ''
  + ''
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
