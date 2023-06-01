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

stdenv.mkDerivation {
  pname = "openems";
  version = "unstable-2020-02-15";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "openEMS";
    rev = "ba793ac84e2f78f254d6d690bb5a4c626326bbfd";
    sha256 = "1dca6b6ccy771irxzsj075zvpa3dlzv4mjb8xyg9d889dqlgyl45";
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
