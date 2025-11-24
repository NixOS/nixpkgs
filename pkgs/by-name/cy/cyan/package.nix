{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  qt5,
  cmake,
  pkg-config,
  imagemagick,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "cyan";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "rodlie";
    repo = "cyan";
    rev = version;
    hash = "sha256-R5sj8AN7UT9OIeUPNrdTIUQvtEitXp1A32l/Z2qRS94=";
  };

  patches = [
    # cmake-4 build fix:
    #   https://github.com/rodlie/cyan/pull/123
    (fetchpatch2 {
      name = "cmake-4.patch";
      url = "https://github.com/rodlie/cyan/commit/885e81310de8df7f32a5e1d2c722f89bcd969cd1.patch?full_index=1";
      hash = "sha256-5VhXKamDNGeEvi86l+R3Lvzb4G5JFBq2dqqd6TdyxZ4=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [ imagemagick ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Image viewer and converter, designed for prepress (print) work";
    homepage = "https://github.com/rodlie/cyan";
    mainProgram = "Cyan";
    license = licenses.cecill21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
