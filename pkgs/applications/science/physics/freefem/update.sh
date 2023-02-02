#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p coreutils curl gawk nix gnused

set -euo pipefail

# Fetch direct FreeFem deps

VERSION="develop"
SOURCE_URL="https://raw.githubusercontent.com/FreeFem/FreeFem-sources/$VERSION/3rdparty/getall"

SOURCES=$(curl -sL "$SOURCE_URL" |
          gawk '
            BEGIN { RS=";" }
            match($0, /download\(([^)]+)/, a) { gsub(/\n|\s|'\''/, "", a[1]); print a[1] }
          ' |
          grep -v '#')

echo "["

for SRC in $SOURCES ; do
    PKG=$(echo "$SRC" | cut -d, -f4)
    URL=$(echo "$SRC" | cut -d, -f2)
    SHA256=$(timeout 20 nix-prefetch-url "$URL" || true)
    if [ -z "$SHA256" ] ; then
        URL="http://pkgs.freefem.org/$PKG"
        SHA256=$(timeout 20 nix-prefetch-url "$URL")
    fi
    cat << EOF
    {
        name = "$PKG";
        url = "$URL";
        sha256 = "$SHA256";
    }
EOF

done


# Fetch petsc deps
# Missing deps will be printed during ff-petsc build

PETSC_DEPS=$(echo "mpich ['https://github.com/pmodels/mpich/releases/download/v4.0.2/mpich-4.0.2.tar.gz', 'https://www.mpich.org/static/downloads/4.0.2/mpich-4.0.2.tar.gz']
hypre ['git://https://github.com/hypre-space/hypre', 'https://github.com/hypre-space/hypre/archive/v2.25.0.tar.gz']
metis ['git://https://bitbucket.org/petsc/pkg-metis.git', 'https://bitbucket.org/petsc/pkg-metis/get/v5.1.0-p10.tar.gz']
slepc ['git://https://gitlab.com/slepc/slepc.git', 'https://gitlab.com/slepc/slepc/-/archive/v3.18.2/slepc-v3.18.2.tar.gz']
suitesparse ['git://https://github.com/DrTimothyAldenDavis/SuiteSparse', 'https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.13.0.tar.gz']
parmetis ['git://https://bitbucket.org/petsc/pkg-parmetis.git', 'https://bitbucket.org/petsc/pkg-parmetis/get/v4.0.3-p8.tar.gz']
ptscotch ['git://https://gitlab.inria.fr/scotch/scotch.git', 'https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.1/scotch-v7.0.1.tar.gz', 'http://ftp.mcs.anl.gov/pub/petsc/externalpackages/scotch-v7.0.1.tar.gz']
mumps ['https://graal.ens-lyon.fr/MUMPS/MUMPS_5.5.1.tar.gz', 'http://ftp.mcs.anl.gov/pub/petsc/externalpackages/MUMPS_5.5.1.tar.gz']
scalapack ['git://https://github.com/Reference-ScaLAPACK/scalapack', 'https://github.com/Reference-ScaLAPACK/scalapack/archive/5bad7487f496c811192334640ce4d3fc5f88144b.tar.gz']
superlu ['git://https://github.com/xiaoyeli/superlu', 'https://github.com/xiaoyeli/superlu/archive/v5.3.0.tar.gz']
hpddm ['git://https://github.com/hpddm/hpddm', 'https://github.com/hpddm/hpddm/archive/v2.2.2.tar.gz']
mmg ['git://https://github.com/prj-/mmg.git', 'https://github.com/prj-/mmg/archive/a6ca7272732cfb05c39b5654057cc1a699d27e39.tar.gz']
parmmg ['git://https://github.com/prj-/ParMmg.git', 'https://github.com/prj-/ParMmg/archive/03d68ed3fbd4dc227f045d63bb61d9b3d499d7df.tar.gz']
tetgen ['http://www.tetgen.org/1.5/src/tetgen1.6.0.tar.gz', 'http://ftp.mcs.anl.gov/pub/petsc/externalpackages/tetgen1.6.0.tar.gz']
f2cblaslapack ['http://ftp.mcs.anl.gov/pub/petsc/externalpackages/f2cblaslapack-3.8.0.q0.tar.gz', 'http://ftp.mcs.anl.gov/pub/petsc/externalpackages/f2cblaslapack-3.8.0.q0.tar.gz']
htool ['git://https://github.com/htool-ddm/htool', 'https://github.com/htool-ddm/htool/archive/a23ddbb86c23d17beb147db43b42502fbe0db0ca.tar.gz']" |
    tr -d ",'[]" |
    cut -d ' ' -f 3)


for URL in $PETSC_DEPS ; do
    NAME=${URL##*/}
    SHA256=$(nix-prefetch-url "$URL")
    cat << EOF
    {
        name = "$NAME";
        url = "$URL";
        sha256 = "$SHA256";
    }
EOF
done

# Fetch slepc deps
# Missing deps will be printed during ff-petsc build

SLEPC_DEPS=$(echo "arpack: https://github.com/opencollab/arpack-ng/archive/5131f792f289c4e63b4cb1f56003e59507910132.tar.gz --> /build/source/3rdparty/pkg/arpack-ng-5131f792f289c4e63b4cb1f56003e59507910132.tar.gz" |
     sed 's|/build/source/3rdparty/pkg/||')


for DEP in "$SLEPC_DEPS" ; do
    URL=$(echo "$DEP" | cut -d ' ' -f 2)
    NAME=$(echo "$DEP" | cut -d ' ' -f 4)
    SHA256=$(nix-prefetch-url "$URL")
    cat << EOF
    {
        name = "$NAME";
        url = "$URL";
        sha256 = "$SHA256";
    }
EOF
done


echo ']'
