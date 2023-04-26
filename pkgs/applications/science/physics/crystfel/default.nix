{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, fetchpatch
, fetchzip
, cmake
, lz4
, bzip2
, m4
, hdf5
, gsl
, unzip
, makeWrapper
, meson
, git
, ninja
, eigen
, pkg-config
, wrapGAppsHook
, flex
, bison
, doxygen
, opencl-headers
, ncurses
, msgpack
, fftw
, zeromq
, ocl-icd
, gtk3
, gdk-pixbuf
, argp-standalone
, memorymappingHook
, withGui ? true
, withBitshuffle ? true
}:

let
  libccp4 = stdenv.mkDerivation rec {
    pname = "libccp4";
    version = "8.0.0";
    src = fetchurl {
      url = "https://ftp.ccp4.ac.uk/opensource/${pname}-${version}.tar.gz";
      hash = "sha256-y4E66GYSoIZjKd6rfO6W6sVz2BvlskA0HUD5rVMi/y0=";
    };
    nativeBuildInputs = [ meson ninja ];
    buildInputs = [ hdf5 gsl ];

    configureFlags = [ "FFLAGS=-fallow-argument-mismatch" ];

    # libccp4 tries to read syminfo.lib by looking at an environment variable, which hinders reproducibility.
    # We hard-code this by providing a little patch and then passing the absolute path to syminfo.lib as a
    # preprocessor flag.
    env.NIX_CFLAGS_COMPILE = "-DNIX_PROVIDED_SYMOP_FILE=\"${placeholder "out"}/share/ccp4/syminfo.lib\"";

    patches = [
      ./libccp4-use-hardcoded-syminfo-lib.patch
    ];

    postPatch =
      let
        mesonPatch = fetchzip {
          url = "https://wrapdb.mesonbuild.com/v2/libccp4c_8.0.0-1/get_patch#somefile.zip";
          hash = "sha256-ohskfKh+972Pl56KtwAeWwHtAaAFNpCzz5vZBAI/vdU=";
        };
      in
      ''
        cp ${mesonPatch}/meson.build .
      '';
  };
  # This is the statically-linked, pre-built binary of mosflm. Compiling it ourselves turns out to be very difficult
  # since the build process is very hard-coded for a specific machine, architecture, and libraries.
  mosflm =
    let
      version = "7.4.0";
      src =
        if stdenv.isDarwin then
          fetchurl
            {
              url = "https://www.mrc-lmb.cam.ac.uk/mosflm/mosflm/ver${builtins.replaceStrings [ "." ] [ "" ] version}/pre-built/mosflm-osx-64-noX11.zip";
              sha256 = "1da5wimv3kl8bccp49j69vh8gi28cn7axg59lrmb38s68c618h7j";
            }
        else
          fetchurl {
            url = "https://www.mrc-lmb.cam.ac.uk/mosflm/mosflm/ver${builtins.replaceStrings [ "." ] [ "" ] version}/pre-built/mosflm-linux-64-noX11.zip";
            sha256 = "1rqh3nprxfmnyihllw31nb8i3wfhybmsic6y7z6wn4rafyv3w4fk";
          };
      mosflmBinary = if stdenv.isDarwin then "bin/mosflm" else "mosflm-linux-64-noX11";
    in
    stdenv.mkDerivation rec {
      pname = "mosflm";

      inherit version src;

      dontBuild = true;

      nativeBuildInputs = [ unzip makeWrapper ];

      sourceRoot = ".";

      # mosflm statically links against its own libccp4, which as the syminfo.lib environment variable problem.
      # Here, we circumvent it by creating a little wrapper script that calls mosflm after setting the SYMINFO variable.
      installPhase = ''
        mkdir -p $out/bin
        cp ${mosflmBinary} $out/bin/mosflm-raw
        makeWrapper $out/bin/mosflm-raw $out/bin/mosflm --set SYMINFO ${libccp4}/share/syminfo.lib --add-flags -n
      '';
    };

  xgandalf = stdenv.mkDerivation rec {
    pname = "xgandalf";
    version = "c15afa2381d5f87d4aefcc8181a15b4a6fd3a955";
    src = fetchurl {
      url = "https://gitlab.desy.de/thomas.white/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
      sha256 = "11i1w57a3rpnb4x5y4n8d3iffn5m9w1zydl69syzljdk3aqg2pv8";
    };

    nativeBuildInputs = [ meson pkg-config ninja ];
    buildInputs = [ eigen ];
  };

  pinkIndexer = stdenv.mkDerivation rec {
    pname = "pinkindexer";
    version = "8a828788f8272a89d484b00afbd2500c2c1ff974";
    src = fetchurl {
      url = "https://gitlab.desy.de/thomas.white/${pname}/-/archive/${version}/${pname}-${version}.tar.gz";
      sha256 = "1mkgf1xd91ay0z0632kzxm0z3wcxf0cayjvs6a3znds72dkhfsyh";
    };

    nativeBuildInputs = [ meson pkg-config ninja ];
    buildInputs = [ eigen ];
  };

  fdip = stdenv.mkDerivation rec {
    pname = "fdip";
    version = "29da626f17f66d5c0780fc59b1eafb7c85b81dd6";
    src = fetchurl {
      url = "https://gitlab.desy.de/philipp.middendorf/fdip/-/archive/${version}/fdip-${version}.tar.gz";
      sha256 = "184l76r4fgznq54rnhgjk7dg41kqdl0d1da02vr5y4cs2fyqppky";
    };

    nativeBuildInputs = [ meson ninja pkg-config ];
    buildInputs = [ eigen ];
  };

  hdf5-external-filter-plugins = stdenv.mkDerivation rec {
    pname = "HDF5-External-Filter-Plugins";
    version = "0.1.0";
    src = fetchFromGitHub {
      owner = "nexusformat";
      repo = pname;
      rev = "49e3b65eca772bca77af13ba047d8b577673afba";
      hash = "sha256-bEzfWdZuHmb0PDzCqy8Dey4tLtq+4coO0sT0GzqrTYI=";
    };

    patches = [
      (fetchpatch {
        url = "https://github.com/spanezz/HDF5-External-Filter-Plugins/commit/6b337fe36da97a3ef72354393687ce3386c0709d.patch";
        hash = "sha256-wnBEdL/MjEyRHPwaVtuhzY+DW1AFeaUQUmIXh+JaRHo=";
      })
    ];

    nativeBuildInputs = [ cmake ];
    buildInputs = [ hdf5 lz4 bzip2 ];

    cmakeFlags = [
      "-DENABLE_BITSHUFFLE_PLUGIN=yes"
      "-DENABLE_LZ4_PLUGIN=yes"
      "-DENABLE_BZIP2_PLUGIN=yes"
    ];
  };
in
stdenv.mkDerivation rec {
  pname = "crystfel";
  version = "0.10.2";
  src = fetchurl {
    url = "https://www.desy.de/~twhite/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-nCO9ndDKS54bVN9IhFBiCVNzqk7BsCljXFrOmlx+sP4=";
  };
  nativeBuildInputs = [ meson pkg-config ninja flex bison doxygen opencl-headers makeWrapper ]
    ++ lib.optionals withGui [ wrapGAppsHook ];
  buildInputs = [
    hdf5
    gsl
    ncurses
    msgpack
    fftw
    fdip
    zeromq
    ocl-icd
    libccp4
    mosflm
    pinkIndexer
    xgandalf
  ] ++ lib.optionals withGui [ gtk3 gdk-pixbuf ]
  ++ lib.optionals stdenv.isDarwin [
    argp-standalone
  ] ++ lib.optionals (stdenv.isDarwin && !stdenv.isAarch64) [
    memorymappingHook
  ]
  ++ lib.optionals withBitshuffle [ hdf5-external-filter-plugins ];

  patches = [
    ./link-to-argp-standalone-if-needed.patch
    ./disable-fmemopen-on-aarch64-darwin.patch
    (fetchpatch {
      url = "https://gitlab.desy.de/thomas.white/crystfel/-/commit/3c54d59e1c13aaae716845fed2585770c3ca9d14.diff";
      hash = "sha256-oaJNBQQn0c+z4p1pnW4osRJA2KdKiz4hWu7uzoKY7wc=";
    })
  ];

  # CrystFEL calls mosflm by searching PATH for it. We could've create a wrapper script that sets the PATH, but
  # we'd have to do that for every CrystFEL executable (indexamajig, crystfel, partialator). Better to just
  # hard-code mosflm's path once.
  postPatch = ''
    sed -i -e 's#execlp("mosflm"#execl("${mosflm}/bin/mosflm"#' libcrystfel/src/indexers/mosflm.c;
  '';

  postInstall = lib.optionalString withBitshuffle ''
    for file in $out/bin/*; do
      wrapProgram $file --set HDF5_PLUGIN_PATH ${hdf5-external-filter-plugins}/lib/plugins
    done
  '';

  meta = with lib; {
    description = "Data processing for serial crystallography";
    longDescription = ''
      CrystFEL is a suite of programs for processing (and simulating) Bragg diffraction data from "serial crystallography" experiments, often (but not always) performed using an X-ray Free-Electron Laser. Compared to rotation data, some of the particular characteristics of such data which call for a specialised software suite are:

      - The sliced, rather than integrated, measurement of intensity data. Many, if not all reflections are partially integrated.
      - Many patterns (thousands) are required - high throughput is needed.
      - The crystal orientations in each pattern are random and uncorrelated.
      - Merging into lower symmetry point groups may require the resolution of indexing ambiguities.'';
    homepage = "https://www.desy.de/~twhite/crystfel/";
    changelog = "https://www.desy.de/~twhite/crystfel/changes.html";
    downloadPage = "https://www.desy.de/~twhite/crystfel/download.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.unix;
  };

}
