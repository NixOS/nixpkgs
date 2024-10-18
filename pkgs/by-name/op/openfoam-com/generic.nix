{
  lib,
  stdenv,
  fetchFromGitLab,
  bash,
  mpi,
  gmp,
  mpfr,
  gnum4,
  makeWrapper,
  makeOverridable,
  flex,
  zlib,
  scotch,
  cgal,
  metis,
  boost,
  removeReferencesTo,

  # Args to override
  version,
  sourceRev,
  sourceHash,

  # For tests
  openfoam,
  callPackage,
}:
stdenv.mkDerivation rec {
  pname = "openfoam-com";

  inherit version;

  src = fetchFromGitLab {
    domain = "develop.openfoam.com";
    owner = "Development";
    repo = "openfoam";
    rev = sourceRev;
    hash = sourceHash;
  };

  nativeBuildInputs = [
    makeWrapper
    bash
    gnum4
    flex
    removeReferencesTo
  ];

  buildInputs =
    [
      boost.dev
      cgal
      metis
      mpi
      zlib
    ]
    ++ lib.optionals (lib.strings.versionOlder version "2306") [
      gmp
      mpfr
    ];

  outputs = [
    "out"
    "dev"
    "tutorials"
  ];

  stripDebugList = [ "platforms" ];
  separateDebugInfo = true;

  postPatch =
    ''
      patchShebangs ./

      echo "system dependencies" > ThirdParty
    ''
    + lib.optionalString (lib.strings.versionOlder version "2406") ''
      substituteInPlace wmake/rules/General/Gcc/c++ \
        --replace-fail "-std=c++11" "-std=c++14 -D_GLIBCXX_USE_CXX14_ABI=0"
    '';

  configurePhase = ''
    bin/tools/foamConfigurePaths \
      -boost-path "${boost.dev}" \
      -cgal-path "${cgal}" \
      -metis-path "${metis}" \
      -scotch-path "${scotch}" \
      -kahip kahip-none

    bin/tools/create-mpi-config -write-openmpi

    set +e
    source etc/bashrc
    set -e
  '';

  buildPhase = ''
    export WM_NCOMPPROCS="$NIX_BUILD_CORES"

    ./Allwmake -j -q
  '';

  installPhase = ''
    mkdir -p "$out" "$dev" "$tutorials"

    cp -av bin "$out/bin"
    cp -av etc "$out/etc"
    cp -av META-INFO "$out/META-INFO"
    cp -av ThirdParty "$out/ThirdParty"

    mkdir -p "$out/platforms"
    cp -av "platforms/$WM_OPTIONS" "$out/platforms/$WM_OPTIONS"

    cp -av wmake "$out/wmake"
    cp -av Allwmake "$out/Allwmake"

    mkdir -p "$out/platforms/tools"
    cp -av "platforms/tools/$WM_ARCH$WM_COMPILER" "$out/platforms/tools/$WM_ARCH$WM_COMPILER"

    cp -av applications "$dev/applications"
    cp -av src "$dev/src"

    cp -av tutorials "$tutorials/tutorials"
  '';

  postFixup = ''
    substituteInPlace $out/etc/bashrc \
      --replace-fail "# projectDir=\"@PROJECT_DIR@\"" "projectDir=\"$out\""

    substituteInPlace $out/etc/config.sh/settings \
      --replace-fail "export FOAM_SRC=\"\$WM_PROJECT_DIR/src\"" "export FOAM_SRC=\"\$NIX_OPENFOAM_COM_DEV/src\"" \
      --replace-fail "export FOAM_TUTORIALS=\"\$WM_PROJECT_DIR/tutorials\"" "export FOAM_TUTORIALS=\"\$NIX_OPENFOAM_COM_TUTORIALS/tutorials\""

    substituteInPlace $out/wmake/makefiles/general \
      --replace-fail "\$(WM_PROJECT_DIR)/src" "\$(NIX_OPENFOAM_COM_DEV)/src" \
      --replace-fail "\$(WM_PROJECT_DIR)/applications" "\$(NIX_OPENFOAM_COM_DEV)/applications"

    remove-references-to -t ${boost.dev} $out/etc/config.sh/CGAL

    echo "creating a bin of wrapped binaries from $out/platforms/$WM_OPTIONS/bin"
    for program in "$out/platforms/$WM_OPTIONS/bin/"*; do
      makeWrapper "$program" "$out/bin/''${program##*/}" \
        --run "set +e; source \"$out/etc/bashrc\"; set -e"

      makeWrapper "${mpi}/bin/mpirun" "$out/bin/''${program##*/}-mpi" \
        --add-flags "-n \"\$(ls -d processor* | wc -l)\" \"$out/bin/''${program##*/}\" -parallel" \
        --run "[ -r processor0 ] || { echo \"Case is not currently decomposed, see decomposePar documentation\"; exit 1; }" \
        --run "set +e; source \"$out/etc/bashrc\"; set -e"
    done
  '';

  disallowedReferences = [ boost.dev ];

  passthru = {
    tests = callPackage ./tests.nix { inherit openfoam; };

    mkExtension = callPackage ./mk-extension.nix { inherit openfoam stdenv mpi; };
  };

  meta = with lib; {
    description = "Free, open source CFD software";
    homepage = "https://develop.openfoam.com/Development/openfoam.git";
    changelog = "https://www.openfoam.com/news/main-news/openfoam-${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ razielgn ];
    platforms = lib.platforms.linux;
  };
}
