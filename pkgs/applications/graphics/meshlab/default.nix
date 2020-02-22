{ mkDerivation, lib, fetchFromGitHub
, fetchpatch
, libGLU
, qtbase
, qtscript
, qtxmlpatterns
, lib3ds
, bzip2
, muparser
, levmar
}:

let
  meshlabRev = "25f3d17b1d1d47ddc51179cb955f3027b7638745";
  vcglibRev = "910da4c3e310f2e6557bd7a39c4f1529e61573e5";
  # ^ this should be the latest commit in the vcglib devel branch at the time of the meshlab revision
  # We keep it separate here instead of using the `vcg` nix package because
  # as of writing, meshlab upstream does not seem to follow a proper
  # release process, and the other dependencies of `vcg` may no longer
  # work when we upgrade it for the purpose of meshlab.

  # Unfixed upstream compile error; see
  #     https://github.com/cnr-isti-vclab/meshlab/issues/188#issuecomment-364785362
  # that has with fixed line endings.
  import_bundle_out_patch = fetchpatch {
    name = "import_bundle_out.patch";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/import_bundle_out.patch?h=meshlab-git&id=f7250ea818470f07dc9b86726407091d39c0be6f";
    sha256 = "1g6nli15i3fjd6jsgkxvb33kzbcv67xjkc3jv9r51lrwlm1ifzxi";
  };

  # Reduces amount of vendored libraries, fixes `/linux` vs `linux-g++`
  # directory name linker errors.
  external_patch = fetchpatch {
    name = "external.patch";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/external.patch?h=meshlab-git&id=f7250ea818470f07dc9b86726407091d39c0be6f";
    sha256 = "1rxwkxhmxis1420rc1w7dg89gkmym68lpszsq6snl6dzpl3ingsb";
  };
  _3ds_patch = fetchpatch {
    name = "3ds.patch";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/3ds.patch?h=meshlab-git&id=f7250ea818470f07dc9b86726407091d39c0be6f";
    sha256 = "1w435b7p1ggi2bzib4yyszmk54drjgpbn8n9mnsk1slsxnp2vmg8";
  };
  muparser_patch = fetchpatch {
    name = "muparser.patch";
    url = "https://aur.archlinux.org/cgit/aur.git/plain/muparser.patch?h=meshlab-git&id=f7250ea818470f07dc9b86726407091d39c0be6f";
    sha256 = "1sf7xqwc2j8xxdx2yklwifii9qqgknvx6ahk2hq76mg78ry1nzhq";
  };

in mkDerivation {
  name = "meshlab-20190129-beta";

  srcs =
    [
      (fetchFromGitHub {
        owner = "cnr-isti-vclab";
        repo = "meshlab";
        rev = meshlabRev;
        sha256 = "16d2i91hrxvrr5p0k33g3fzis9zp4gsy3n5y2nhafvsgdmaidiij";
        name = "meshlab-${meshlabRev}";
      })
      (fetchFromGitHub {
        owner = "cnr-isti-vclab";
        repo = "vcglib";
        rev = vcglibRev;
        sha256 = "0xpnjpwpj57hgai184rzyk9lbq6d9vbjzr477dvl5nplpwa420m1";
        name = "vcglib-${vcglibRev}";
      })
    ];

  sourceRoot = "meshlab-${meshlabRev}";

  # Meshlab is not format-security clean; without disabling hardening, we get:
  #     ../../external/qhull-2003.1/src/io.c:2169:3: error: format not a string literal and no format arguments [-Werror=format-security]
  #        fprintf(fp, endfmt);
  #        ^~~~~~~
  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  prePatch =
    ''
      # MeshLab has ../vcglib hardcoded everywhere, so move the source dir
      mv ../vcglib-${vcglibRev} ../vcglib

      # Make all source files writable so that patches can be applied.
      chmod -R u+w ..

      patch -Np1 --directory=../vcglib -i ${import_bundle_out_patch}

      patch -Np1 -i ${external_patch}
      # Individual libraries
      patch -Np1 -i ${_3ds_patch}
      patch -Np1 -i ${muparser_patch}
    ''
    ;

  buildPhase = ''
    cd src
    export NIX_LDFLAGS="-rpath $out/opt/meshlab $NIX_LDFLAGS"

    pushd external
    qmake -recursive $QMAKE_FLAGS external.pro
    buildPhase
    popd
    qmake -recursive $QMAKE_FLAGS meshlab_full.pro
    buildPhase
  '';

  installPhase = ''
    mkdir -p $out/opt/meshlab $out/bin
    cp -Rv distrib/* $out/opt/meshlab
    ln -s $out/opt/meshlab/meshlab $out/bin/meshlab
    ln -s $out/opt/meshlab/meshlabserver $out/bin/meshlabserver
  '';

  buildInputs = [
    libGLU
    qtbase
    qtscript
    qtxmlpatterns
    lib3ds
    bzip2
    muparser
    levmar
  ];

  meta = {
    description = "A system for processing and editing 3D triangular meshes.";
    homepage = http://www.meshlab.net/;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
