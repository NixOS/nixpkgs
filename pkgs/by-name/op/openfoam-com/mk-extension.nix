{
  openfoam,
  stdenv,
  mpi,
  makeWrapper,
}:

let
  inherit (openfoam) pname version;
in

{ name, src }:

stdenv.mkDerivation {
  name = "${pname}-ext-${name}";

  inherit src;

  nativeBuildInputs = [ makeWrapper ];

  configurePhase = ''
    export NIX_OPENFOAM_COM_DEV=${openfoam.dev}

    set +e
    source ${openfoam}/etc/bashrc
    set -e
  '';

  buildPhase = ''
    export WM_NCOMPPROCS="$NIX_BUILD_CORES"

    export FOAM_USER_APPBIN=$(pwd)/build/bin
    export FOAM_USER_LIBBIN=$(pwd)/build/lib

    mkdir -p build/bin
    mkdir -p build/lib

    wmake -j
  '';

  installPhase = ''
    mkdir $out

    cp -arv build/bin $out/bin
    cp -arv build/lib $out/lib
  '';

  postFixup = ''
    echo "creating a bin of wrapped binaries from $out/bin"

    for program in "$out/bin/"*; do
      makeWrapper "${mpi}/bin/mpirun" "$out/bin/''${program##*/}-mpi" \
        --add-flags "-n \"\$(ls -d processor* | wc -l)\" \"$out/bin/''${program##*/}\" -parallel" \
        --run "[ -r processor0 ] || { echo \"Case is not currently decomposed, see decomposePar documentation\"; exit 1; }" \
        --run "set +e; source \"${openfoam}/etc/bashrc\"; set -e"

      wrapProgram "$program" \
        --run "set +e; source \"${openfoam}/etc/bashrc\"; set -e"
    done
  '';
}
