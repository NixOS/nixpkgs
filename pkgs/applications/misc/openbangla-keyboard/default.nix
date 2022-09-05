{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, rustPlatform
, wrapQtAppsHook
, ibus
, qtbase
, zstd
}:

stdenv.mkDerivation rec {
  pname = "openbangla-keyboard";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "openbangla";
    repo = "openbangla-keyboard";
    rev = version;
    hash = "sha256-UoLiysaA0Wob/SLBqm36Txqb8k7bwoQ56h8ZufHR74I=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    rustPlatform.cargoSetupHook
    wrapQtAppsHook
  ];

  buildInputs = [
    ibus
    qtbase
    zstd
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
    '';
    sourceRoot = "source/${cargoRoot}";
    sha256 = "sha256-01MWuUUirsgpoprMArRp3qxKNayPHTkYWk31nXcIC34=";
  };

  cargoRoot = "src/engine/riti";
  postPatch = ''
    cp ${./Cargo.lock} ${cargoRoot}/Cargo.lock

    substituteInPlace CMakeLists.txt \
      --replace "/usr" "$out"

    substituteInPlace src/shared/FileSystem.cpp \
      --replace "/usr" "$out"
  '';

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/share/openbangla-keyboard/openbangla-gui $out/bin/openbangla-gui
  '';

  meta = with lib; {
    description = "An OpenSource, Unicode compliant Bengali Input Method";
    homepage = "https://openbangla.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hqurve ];
    platforms = platforms.linux;
  };
}
