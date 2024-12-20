{ stdenv
, lib
, fetchFromGitHub
, csxcad
, fparser
, tinyxml
, hdf5
, vtk
, boost
, zlib
, cmake
, octave
, mpi
, withQcsxcad ? true
, withMPI ? false
, withHyp2mat ? true
, qcsxcad
, hyp2mat
}:

stdenv.mkDerivation rec {
  pname = "openems";
  version = "0.0.36";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "openEMS";
    rev = "v${version}";
    sha256 = "sha256-wdH+Zw7G2ZigzBMX8p3GKdFVx/AhbTNL+P3w+YjI/dc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = lib.optionals withMPI [ "-DWITH_MPI=ON" ];

  buildInputs = [
    fparser
    tinyxml
    hdf5
    vtk
    boost
    zlib
    csxcad
    (octave.override { inherit hdf5; }) ]
    ++ lib.optionals withQcsxcad [ qcsxcad ]
    ++ lib.optionals withMPI [ mpi ]
    ++ lib.optionals withHyp2mat [ hyp2mat ];

  postFixup = ''
    substituteInPlace $out/share/openEMS/matlab/setup.m \
      --replace /usr/lib ${hdf5}/lib \
      --replace /usr/include ${hdf5}/include

    ${octave}/bin/mkoctfile -L${hdf5}/lib -I${hdf5}/include \
      -lhdf5 $out/share/openEMS/matlab/h5readatt_octave.cc \
      -o $out/share/openEMS/matlab/h5readatt_octave.oct
  '';

  meta = with lib; {
    description = "Open Source Electromagnetic Field Solver";
    homepage = "http://openems.de/index.php/Main_Page.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
    badPlatforms = platforms.aarch64;
  };
}
