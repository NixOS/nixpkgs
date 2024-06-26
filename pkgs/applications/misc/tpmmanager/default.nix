{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  qtbase,
  qmake,
  wrapQtAppsHook,
  trousers,
}:

stdenv.mkDerivation rec {
  version = "0.8.1";
  pname = "tpmmanager";

  src = fetchFromGitHub {
    owner = "Rohde-Schwarz";
    repo = "TPMManager";
    rev = "v${version}";
    sha256 = "sha256-UZYn4ssbvLpdB0DssT7MXqQZCu1KkLf/Bsb45Rvgm+E=";
  };

  patches = [
    # build with Qt5
    (fetchpatch {
      url = "https://github.com/Rohde-Schwarz/TPMManager/commit/f62c0f2de2097af9b504c80d6193818e6e4ca84f.patch";
      sha256 = "sha256-gMhDNN2UkX2lJf/oJEzOkCvF6+EGdIj9xwtXb1rCeys=";
    })
    (fetchpatch {
      url = "https://github.com/Rohde-Schwarz/TPMManager/commit/c287a841ac6b057ed35799949211866b9f533561.patch";
      sha256 = "sha256-2ZyUml8Q9bKQLVZWr18AzLt8VYLICXH9VDeq6B5Xfto=";
    })
  ];

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    trousers
  ];

  installPhase = ''
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
  '';

  meta = {
    homepage = "https://projects.sirrix.com/trac/tpmmanager";
    description = "Tool for managing the TPM";
    mainProgram = "tpmmanager";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
