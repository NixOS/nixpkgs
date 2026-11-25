{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  hdf5,
  lz4,
  bzip2,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hdf5-external-filter-plugins";
  version = "0.1.0-unstable-2022-11-11";

  src = fetchFromGitHub {
    owner = "nexusformat";
    repo = "HDF5-External-Filter-Plugins";
    rev = "49e3b65eca772bca77af13ba047d8b577673afba";
    hash = "sha256-bEzfWdZuHmb0PDzCqy8Dey4tLtq+4coO0sT0GzqrTYI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/spanezz/HDF5-External-Filter-Plugins/commit/6b337fe36da97a3ef72354393687ce3386c0709d.patch";
      hash = "sha256-wnBEdL/MjEyRHPwaVtuhzY+DW1AFeaUQUmIXh+JaRHo=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0.0)" \
        "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    hdf5
    lz4
    bzip2
  ];

  cmakeFlags = [
    "-DENABLE_BITSHUFFLE_PLUGIN=yes"
    "-DENABLE_LZ4_PLUGIN=yes"
    "-DENABLE_BZIP2_PLUGIN=yes"
  ];

  doCheck = true;
  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "Dynamically loadable (compression) filters for HDF5";
    homepage = "https://github.com/nexusformat/HDF5-External-Filter-Plugins";
    license =
      with lib.licenses;
      AND [
        (mkLicense {
          shortName = "hdf5-plugins";
          url = "https://github.com/nexusformat/HDF5-External-Filter-Plugins/blob/master/BZIP2/COPYING";
        })
        mit
      ];
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.unix;
  };
})
