{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "obs-composite-blur";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-composite-blur";
    rev = "refs/tags/v${version}";
    hash = "sha256-icn0X+c7Uf0nTFaVDVTPi26sfWTSeoAj7+guEn9gi9Y=";
  };

  buildInputs = [
    obs-studio
  ];

  nativeBuildInputs = [
    cmake
  ];

  postInstall = ''
    rm -rf "$out/share"
    mkdir -p "$out/share/obs"
    mv "$out/data/obs-plugins" "$out/share/obs"
    rm -rf "$out/obs-plugins" "$out/data"
  '';

  meta = with lib; {
    description = "Comprehensive blur plugin for OBS that provides several different blur algorithms, and proper compositing";
    homepage = "https://github.com/FiniteSingularity/obs-composite-blur";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "obs-composite-blur";
    platforms = platforms.linux;
  };
}
