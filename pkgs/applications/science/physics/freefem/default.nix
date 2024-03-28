{ stdenv
, lib
, fetchurl
, fetchFromGitHub
, autoreconfHook
, writeScript
, bison
, flex
, unzip
, cmake
, python3
, gnutar
, gfortran
, wget
, git
, perl
, which
, pkg-config

, freeglut
, libGL
, libGLU
, hdf5
, gsl
}:

let
  # There's no network during nix-build, so the 3rdparty/getall script wont
  # work. Instead we write a dummy with only the package names as comments,
  # brcause they are used by some makefiles.
  fakeGetall = with lib; pipe (import ./3rdparty.nix) [
    (map ({ name, ... }: "# '${name}'"))
    (concatStringsSep "\n")
    (writeScript "getall")
  ];

  # We pre-download all external dependencies and put them in 3rdparty/pkg/.
  # Some packages also need patching.
  externalLibs =
    let
      # don't remove root folder in tarfile
      keepStructure = { unpackPhase = "${gnutar}/bin/tar -xzf $src"; };
      patchShebangs = { nativeBuildInputs = [ perl python3 ]; postPatch = "patchShebangs ."; };

      # Unpack tarfile, apply overrides, repack
      mkOverride = src: stdenv.mkDerivation ({
        inherit (src) name;
        inherit src;
        dontConfigure = true;
        dontInstall = true;
        buildPhase = "tar -czf $out .";
      } // overrides."${src.name}");

      overrides = {
        # mmg
        "a6ca7272732cfb05c39b5654057cc1a699d27e39.tar.gz" = keepStructure // patchShebangs;
        # parmmg
        "03d68ed3fbd4dc227f045d63bb61d9b3d499d7df.tar.gz" = keepStructure // patchShebangs;
        # hypre
        "v2.25.0.tar.gz" = keepStructure // patchShebangs // {
          prePatch = ''
            substituteInPlace */src/docs/Makefile */src/docs/ref-manual/Makefile \
              --replace '/bin/rm' rm
          '';
        };
        # Patch error in build script
        "petsc-3.18.4.tar.gz" = patchShebangs // { patches = [ ./petsc.patch ]; };
      };
    in
    with lib; pipe (import ./3rdparty.nix) [
      (map ({ name, url, sha256 }:
        let
          src = fetchurl { inherit url sha256; };
          pkg =
            if hasAttr name overrides
            then mkOverride src
            else src;
        in
        "cp ${pkg} ./3rdparty/pkg/${name}"))
      (concatStringsSep "\n")
    ];
in

stdenv.mkDerivation rec {
  pname = "freefem";
  version = "unstable-2023-02-27";

  src = fetchFromGitHub {
    owner = "FreeFem";
    repo = "FreeFem-sources";
    rev = "a4294467dda86eba357edbd76276962f0c4fe3ef";
    sha256 = "sha256-xfIAv4+yXCXQ5ekQRf11jS3QzwVtDUWiTlYTA5Oobrw=";
  };

  patches = [ ./shebangs.patch ./tests.patch ];

  postPatch = ''
    patchShebangs .

    sed -i '/chown/d' ./3rdparty/ff-petsc/Makefile

    # use pre-downloaded dependencies
    substituteInPlace ./3rdparty/ff-petsc/Makefile \
      --replace '~/.petsc_pkg' "$(pwd)/3rdparty/pkg"
  '';

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    cmake
    pkg-config
    python3
    gfortran
    unzip
    wget
    git
    perl
    which
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [
    (hdf5.override { cppSupport = true; fortranSupport = true; }).dev
    gsl

    freeglut.dev
    libGL.dev
    libGLU.dev
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    configureFlagsArray=(
      --enable-download
      --enable-optim
      --enable-generic
      --enable-opengl
      --enable-summary
    )
  '';

  postConfigure = ''
    mkdir ./3rdparty/pkg
    ${externalLibs}

    cp -f ${fakeGetall} ./3rdparty/getall
  '';

  preBuild = ''
    pushd ./3rdparty/ff-petsc
    make petsc-slepc
    popd
    ./reconfigure
  '';

  doCheck = true;


  meta = with lib; {
    description = "A high level multiphysics finite element software";
    longDescription = ''
      FreeFEM is a popular 2D and 3D partial differential equations (PDE)
      solver used by thousands of researchers across the world.

      It allows you to easily implement your own physics modules using the
      provided FreeFEM language. FreeFEM offers a large list of finite
      elements, like the Lagrange, Taylor-Hood, etc., usable in the
      continuous and discontinuous Galerkin method framework.
    '';
    homepage = "https://freefem.org";
    changelog = "https://github.com/FreeFem/FreeFem-sources/blob/${src.rev}/CHANGELOG.md";
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
