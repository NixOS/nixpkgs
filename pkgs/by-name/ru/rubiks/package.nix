{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  coreutils,
  dos2unix,
}:

stdenv.mkDerivation rec {
  pname = "rubiks";
  version = "20070912";

  src = fetchurl {
    url = "mirror://sageupstream/rubiks/rubiks-${version}.tar.bz2";
    sha256 = "0zdmkb0j1kyspdpsszzb2k3279xij79jkx0dxd9f3ix1yyyg3yfq";
  };

  preConfigure = ''
    export INSTALL="${coreutils}/bin/install"
  '';

  # everything is done in `make install`
  dontBuild = true;

  installFlags = [
    "PREFIX=$(out)"
  ];

  nativeBuildInputs = [ dos2unix ];

  prePatch = ''
    find ./dietz/ -type f -exec dos2unix {} \;
  '';

  patches = [
    # Fix makefiles which use all the variables in all the wrong ways and
    # hardcode values for some variables.
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/dietz-cu2-Makefile.patch";
      sha256 = "bRU7MJ/6BgCp2PUqZOragJhm38Q3E8ShStXQIYwIjvw=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/dietz-mcube-Makefile.patch";
      sha256 = "f53z4DogXKax1vUNkraOTt3TQ4bvT7CdQK/hOaaBS38=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/dietz-solver-Makefile.patch";
      sha256 = "7gMC8y9elyIy2KvXYcp7YjPBNqn9PVhUle+/GrYAAdE=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/reid-Makefile.patch";
      sha256 = "rp3SYtx02vVBtSlg1vJpdIoXNcdBNKDLCLqLAKwOYeQ=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/fedora-1-rubiks-includes.patch";
      sha256 = "QYJ1KQ73HTEGY/beMVbcU215g/B8rHDjYD1YM2WZ7sk=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/fedora-2-rubiks-ansi-c.patch";
      sha256 = "Rnu7uphE9URxnbg2K8mkymnB61magweH+WxVWR9JC4s=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/fedora-3-rubiks-prototypes.patch";
      sha256 = "Wi038g+y7No1TNMiITtAdipjRi0+g6h0Sspslm5rZGU=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/fedora-4-rubiks-longtype.patch";
      sha256 = "6pNuxFM69CZ/TQGZfHXLlCN5g5lf3RiYYZKzMvLJwkw=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/fedora-5-rubiks-signed.patch";
      sha256 = "CCGXBMYvSjTm4YKQZAQMi6pWGjyHDYYQzdMZDSW2vFE=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/sagemath/sage/2a9a4267f93588cf33119cbacc032ed9acc433e5/build/pkgs/rubiks/patches/fedora-6-rubiks-attributes.patch";
      sha256 = "RhlzMb33iaLfeBoF7Y0LIgEzOB/EC+AoWMSkRPCICaU=";
    })
  ];

  meta = with lib; {
    homepage = "https://wiki.sagemath.org/spkg/rubiks";
    description = "Several programs for working with Rubik's cubes";
    # The individual websites are no longer available
    longDescription = ''
      There are several programs for working with Rubik's cubes, by three
      different people. Look inside the directories under /src to see
      specific info and licensing. In summary the three contributers are:


      Michael Reid (GPL) http://www.math.ucf.edu/~reid/Rubik/optimal_solver.html
          optimal - uses many pre-computed tables to find an optimal
                    solution to the 3x3x3 Rubik's cube


      Dik T. Winter (MIT License)
          cube    - uses Kociemba's algorithm to iteratively find a short
                    solution to the 3x3x3 Rubik's cube
          size222 - solves a 2x2x2 Rubik's cube


      Eric Dietz (GPL) http://www.wrongway.org/?rubiksource
          cu2   - A fast, non-optimal 2x2x2 solver
          cubex - A fast, non-optimal 3x3x3 solver
          mcube - A fast, non-optimal 4x4x4 solver
    '';
    license = with licenses; [
      gpl2 # Michael Reid's and Eric Dietz software
      mit # Dik T. Winter's software
    ];
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
}
