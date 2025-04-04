{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qmake,
  wrapQtAppsHook,
  trousers,
}:

stdenv.mkDerivation rec {
  pname = "tpmmanager";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Rohde-Schwarz";
    repo = "TPMManager";
    tag = "v${version}";
    hash = "sha256-FhdrUJQq4us6BT8CxgWqWiXnbl900204yjyS3nnQACU=";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    trousers
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dpm755 -D bin/tpmmanager $out/bin/tpmmanager

    mkdir -p $out/share/applications
    cat > $out/share/applications/tpmmanager.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=tpmmanager
    Comment=TPM manager
    Exec=$out/bin/tpmmanager
    Terminal=false
    EOF

    runHook postInstall
  '';

  meta = {
    homepage = "https://projects.sirrix.com/trac/tpmmanager";
    description = "Tool for managing the TPM";
    mainProgram = "tpmmanager";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
