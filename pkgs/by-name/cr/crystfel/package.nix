{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  fetchpatch,
  fetchzip,
  cmake,
  lz4,
  gfortran,
  bzip2,
  hdf5,
  gsl,
  unzip,
  makeWrapper,
  zlib,
  meson,
  ninja,
  pandoc,
  eigen,
  pkg-config,
  wrapGAppsHook3,
  flex,
  bison,
  doxygen,
  opencl-headers,
  ncurses,
  msgpack-c,
  fftw,
  zeromq,
  ocl-icd,
  gtk3,
  gdk-pixbuf,
  argp-standalone,
  withGui ? true,
  withBitshuffle ? true,
}:

let
  libccp4 = stdenv.mkDerivation rec {
    pname = "libccp4";
    version = "8.0.0";
    src = fetchurl {
      url = "https://ftp.ccp4.ac.uk/opensource/libccp4-${version}.tar.gz";
      hash = "sha256-y4E66GYSoIZjKd6rfO6W6sVz2BvlskA0HUD5rVMi/y0=";
    };
    nativeBuildInputs = [
      meson
      ninja
    ];
    buildInputs = [
      hdf5
      gsl
    ];

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

        substituteInPlace ccp4/library_utils.c \
          --replace-fail "  int putenv ();" "  int putenv (char *);"
      '';
  };
  # This is the statically-linked, pre-built binary of mosflm. Compiling it ourselves turns out to be very difficult
  # since the build process is very hard-coded for a specific machine, architecture, and libraries.
  mosflm =
    let
      version = "7.4.0";
      src =
        if stdenv.hostPlatform.isDarwin then
          fetchurl {
            url = "https://www.mrc-lmb.cam.ac.uk/harry/imosflm/ver${
              builtins.replaceStrings [ "." ] [ "" ] version
            }/downloads/imosflm-${version}-osx-64.zip";
            hash = "sha256-0sXgA3zSIjhy9+zTiv+K/51yZsIgGorMtKVjdRjW+AM=";
          }
        else
          fetchurl {
            url = "https://www.mrc-lmb.cam.ac.uk/harry/imosflm/ver${
              builtins.replaceStrings [ "." ] [ "" ] version
            }/downloads/imosflm-${version}-linux-64.zip";
            hash = "sha256-2we0K09W31LKgn9SHLGti50EA/zhbX+CWWuQGCSKW18=";
          };
    in
    stdenv.mkDerivation {
      pname = "mosflm";

      inherit version src;

      dontBuild = true;

      nativeBuildInputs = [
        unzip
        makeWrapper
      ];

      # mosflm statically links against its own libccp4, which as the syminfo.lib environment variable problem.
      # Here, we circumvent it by creating a little wrapper script that calls mosflm after setting the SYMINFO variable.
      installPhase = ''
        mkdir -p $out/bin
        cp bin/mosflm $out/bin/mosflm-raw
        makeWrapper $out/bin/mosflm-raw $out/bin/mosflm --set SYMINFO ${libccp4}/share/syminfo.lib --add-flags -n
      '';
    };

  xgandalf = stdenv.mkDerivation rec {
    pname = "xgandalf";
    version = "8a63600ec778b155031adc3c151424aaced6a0cc";
    src = fetchurl {
      url = "https://gitlab.desy.de/thomas.white/xgandalf/-/archive/${version}/xgandalf-${version}.tar.gz";
      hash = "sha256-UhFbpv+4qMwxEQIJpVpMzSg46P0vm0dkEyJDzxVu6XY=";
    };

    nativeBuildInputs = [
      meson
      pkg-config
      ninja
    ];
    buildInputs = [ eigen ];
  };

  pinkIndexer = stdenv.mkDerivation rec {
    pname = "pinkindexer";
    version = "85f3883f8c1fe98a03e5f3d371f2da4fee97894e";
    src = fetchurl {
      url = "https://gitlab.desy.de/thomas.white/pinkindexer/-/archive/${version}/pinkindexer-${version}.tar.gz";
      hash = "sha256-W4COYdeESP0S2KhB2UdaJSbxNiFm5yyapKkmICDtP0A=";
    };

    nativeBuildInputs = [
      meson
      pkg-config
      ninja
    ];
    buildInputs = [ eigen ];
  };

  fdip = stdenv.mkDerivation rec {
    pname = "fdip";
    version = "631792e90ed2c3e226dce77bf97917305293ac66";
    src = fetchurl {
      url = "https://gitlab.desy.de/thomas.white/fdip/-/archive/${version}/fdip-${version}.tar.gz";
      hash = "sha256-nnvOPl35NgtJ13fgWWAuVhtWT/JOk2DyYmBgI0ojZ2o=";
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];
    buildInputs = [ eigen ];
  };

  hdf5-external-filter-plugins = stdenv.mkDerivation {
    pname = "HDF5-External-Filter-Plugins";
    version = "0.1.0";
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
  };

  millepede-ii = stdenv.mkDerivation rec {
    pname = "millepede-ii";
    version = "04-13-06";
    src = fetchurl {
      url = "https://gitlab.desy.de/claus.kleinwort/millepede-ii/-/archive/V${version}/millepede-ii-V${version}.tar.gz";
      hash = "sha256-aFoo8AGBsUEN2u3AmnSpTqJ6JeNV6j9vkAFTZ34I+sI=";
    };

    nativeBuildInputs = [ gfortran ];
    buildInputs = [ zlib ];

    makeFlags = [ "PREFIX=$(out)" ];
  };
in
stdenv.mkDerivation rec {
  pname = "crystfel";
  version = "0.13.0";
  src = fetchurl {
    url = "https://www.desy.de/~twhite/crystfel/crystfel-${version}.tar.gz";
    sha256 = "sha256-6Fz7W8kRKlaTmnL+21t20UgkTjr3oC08IOzAGOseaQU=";
  };
  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    flex
    bison
    doxygen
    opencl-headers
    makeWrapper
  ]
  ++ lib.optionals withGui [ wrapGAppsHook3 ];
  buildInputs = [
    hdf5
    gsl
    ncurses
    msgpack-c
    fftw
    fdip
    zeromq
    ocl-icd
    libccp4
    mosflm
    pinkIndexer
    xgandalf
    pandoc
  ]
  ++ lib.optionals withGui [
    gtk3
    gdk-pixbuf
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    argp-standalone
  ]
  ++ lib.optionals withBitshuffle [ hdf5-external-filter-plugins ];

  # CrystFEL calls mosflm by searching PATH for it. We could've create a wrapper script that sets the PATH, but
  # we'd have to do that for every CrystFEL executable (indexamajig, crystfel, partialator). Better to just
  # hard-code mosflm's path once.
  postPatch = ''
    sed -i -e 's#execlp("mosflm"#execl("${mosflm}/bin/mosflm"#' libcrystfel/src/indexers/mosflm.c;
  '';

  postInstall = lib.optionalString withBitshuffle ''
    for file in $out/bin/*; do
      wrapProgram $file \
        --set HDF5_PLUGIN_PATH ${hdf5-external-filter-plugins}/lib/plugins \
        --prefix PATH ":" ${lib.makeBinPath [ millepede-ii ]}
    done
  '';

  meta = {
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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.unix;
  };

}
