{
  cmake,
  fetchFromGitHub,
  gfortran,
  glibc,
  lib,
  libGL,
  patchelf,
  python3,
  stdenv,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "energyplus";
  version = "24.1.0";

  src = lib.cleanSourceWith {
    filter =
      path: _:
      let
        pathDoesntContain = regex: (builtins.match regex path) == null;
        removeSet = [
          "datasets"
          "weather"
        ];
      in
      lib.pipe removeSet [
        (map pathDoesntContain)
        (builtins.all lib.id)
      ];
    src = fetchFromGitHub {
      owner = "NREL";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-g8lWijcZvNkFclSiStU+7HWfm+F8LobP2kIJNV6zczE=";
    };
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    libGL
    glibc.static
    gfortran
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
  ];

  cmakeFlags = [
    "-DBUILD_FORTRAN=ON"
    "-DBUILD_PACKAGE=ON"
    # "-DENABLE_UNITY=ON"
    # "-DSINGLE_PROJECT=OFF" # disable windows builds
    # "-DLINK_WITH_PYTHON=ON"
  ];

  makeFlags = [
    "package"
    # "-j1"
  ];

  postInstall = ''
    # binaries
    mkdir -p $out/bin
    # main binary that ships with the repo
    cp $out/${pname}-${version} $out/bin/${pname}
    # secondary utility binary shipping with the repo
    cp $out/ConvertInputFormat-${version} $out/bin/ConvertInputFormat

    # libraries
    mkdir -p $out/lib
    # put lib into the right spot so it can actually be found
    cp $out/lib${pname}api.so.${version} $out/lib
  '';

  # this would remove references to libenergyplus from the binaries
  # dontPatchELF = true;

  meta = with lib; {
    description = "A whole building energy simulation program to model both energy consumption and water use";
    homepage = "https://github.com/NREL/EnergyPlus";
    license = licenses.energyplus;
    mainProgram = "energyplus";
    maintainers = with maintainers; [ robwalt ];
  };
}
