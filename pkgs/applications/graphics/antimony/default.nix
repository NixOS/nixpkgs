{ stdenv, fetchgit, libpng, python3, boost, mesa, qtbase, ncurses }:

let
  gitRev    = "745eca3a2d2657c495d5509e9083c884e021d09c";
  gitBranch = "master";
  gitTag    = "0.8.0b";
in 
  stdenv.mkDerivation rec {
    name    = "antimony-${version}";
    version = gitTag;

    src  = fetchgit {
      url         = "git://github.com/mkeeter/antimony.git";
      rev         = gitRev;
      sha256      = "19ir3y5ipmfyygcn8mbxika4j3af6dfrv54dvhn6maz7dy8h30f4";
    };

    patches = [ ./paths-fix.patch ];
    # fix build with glibc-2.23
    postPatch = ''
      sed 's/\<isinf(/std::isinf(/g' -i \
        src/export/export_heightmap.cpp \
        src/fab/types/bounds.cpp \
        src/graph/hooks/meta.cpp \
        src/ui/dialogs/resolution_dialog.cpp \
        src/render/render_task.cpp
    '';

    buildInputs = [
      libpng python3 (boost.override { python = python3; })
      mesa qtbase ncurses
    ];

    configurePhase = ''
      export GITREV=${gitRev}
      export GITBRANCH=${gitBranch}
      export GITTAG=${gitTag}

      cd qt
      export sourceRoot=$sourceRoot/qt
      qmake antimony.pro PREFIX=$out
    '';

    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      description = "A computer-aided design (CAD) tool from a parallel universe";
      homepage    = "https://github.com/mkeeter/antimony";
      license     = licenses.mit;
      platforms   = platforms.linux;
    };
  }
