{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, cmake
, lz4
, bzip2
, gfortran
, m4
, hdf5
, gsl
, slurm
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
    version = "6.5.1";
    src = fetchurl {
      # Original mirror, now times out
      # url = "ftp://ftp.ccp4.ac.uk/opensource/${pname}-${version}.tar.gz";
      url = "https://deb.debian.org/debian/pool/main/libc/${pname}/${pname}_${version}.orig.tar.gz";
      sha256 = "1rfvjliny29vy5bdi6rrjaw9hhhhh72pw536xwvqipqcjlylf2r8";
    };
    nativeBuildInputs = [ gfortran m4 ];
    buildInputs = [ hdf5 gsl ];

    configureFlags = [ "FFLAGS=-fallow-argument-mismatch" ];

    # libccp4 tries to read syminfo.lib by looking at an environment variable, which hinders reproducibility.
    # We hard-code this by providing a little patch and then passing the absolute path to syminfo.lib as a
    # preprocessor flag.
    preBuild = ''
      makeFlagsArray+=(CFLAGS='-DNIX_PROVIDED_SYMOP_FILE=\"$out/share/syminfo.lib\"')
      export NIX_LDFLAGS="-L${gfortran.cc}/lib64 -L${gfortran.cc}/lib $NIX_LDFLAGS";
    '';
    makeFlags = [ "CFLAGS='-DNIX_PROVIDED_SYMOP_FILE=\"${placeholder "out"}/share/syminfo.lib\"" ];

    patches = [
      ./libccp4-use-hardcoded-syminfo-lib.patch
      ./0002-fix-ftbfs-with-gcc-10.patch
    ];
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
      rev = "d469f175e5273c1d488e71a6134f84088f57d39c";
      sha256 = "1jrzzh75i68ad1yrim7s1nx9wy0s49ghkziahs71mm5azprm6gh9";
    };

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
  version = "0.10.1";
  src = fetchurl {
    url = "https://www.desy.de/~twhite/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0i9d5ggalic7alj97dxjdys7010kxhm2cb4lwakvigl023j8ms79";
  };
  nativeBuildInputs = [ meson pkg-config ninja flex bison doxygen opencl-headers ]
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
    memorymappingHook
  ]
  # slurm is not available for Darwin; when it is, remove the condition
  ++ lib.optionals (!stdenv.isDarwin) [ slurm ]
  # hdf5-external-filter-plugins doesn't link on Darwin
  ++ lib.optionals (withBitshuffle && !stdenv.isDarwin) [ hdf5-external-filter-plugins ];

  patches = [ ./link-to-argp-standalone-if-needed.patch ];

  # CrystFEL calls mosflm by searching PATH for it. We could've create a wrapper script that sets the PATH, but
  # we'd have to do that for every CrystFEL executable (indexamajig, crystfel, partialator). Better to just
  # hard-code mosflm's path once.
  postPatch = ''
    sed -i -e 's#execlp("mosflm"#execl("${mosflm}/bin/mosflm"#' libcrystfel/src/indexers/mosflm.c;
  '';

  postInstall = lib.optionalString (withBitshuffle && !stdenv.isDarwin) ''
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
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

}
