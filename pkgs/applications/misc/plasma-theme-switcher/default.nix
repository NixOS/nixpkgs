{
  stdenv,
  lib,
  cmake,
  extra-cmake-modules,
  fetchFromGitHub,
  qtbase,
  kdeFrameworks,
}:

stdenv.mkDerivation rec {
  pname = "plasma-theme-switcher";
  version = "0.1";
  dontWrapQtApps = true;

  src = fetchFromGitHub {
    owner = "maldoinc";
    repo = "plasma-theme-switcher";
    rev = "v${version}";
    sha256 = "sdcJ6K5QmglJEDIEl4sd8x7DuCPCqMHRxdYbcToM46Q=";
  };

  buildInputs = [
    qtbase
    kdeFrameworks.plasma-framework
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp plasma-theme $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/maldoinc/plasma-theme-switcher/";
    description = "KDE Plasma theme switcher";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ kevink ];
    mainProgram = "plasma-theme";
  };
}
