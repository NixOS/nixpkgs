{ stdenv, lib, pkgs, fetchFromGitHub
, build_variant ? "opt"
, isas ? [ "X86" "ARM" "RISCV" ]
}:
stdenv.mkDerivation rec {
  pname = "gem5";
  version = "22.1.0.0";

  src = fetchFromGitHub {
    owner = "gem5";
    repo = "gem5";
    rev = "v${version}";
    sha256 = "sha256-Yxag8emR6hf7oX4GAtQi/YYcKrpXicUoQg5+rjKyjc0=";
  };

  nativeBuildInputs = [pkgs.scons];

  buildInputs = with pkgs;[
    doxygen
    git
    gnum4
    gperftools
    hdf5-cpp
    libpng
    ncurses
    pcre
    pkg-config
    protobuf
    (python3.withPackages (ps: with ps; [
      pip
      pydot
      virtualenv
    ]))
    scons
    zlib
  ];

  sconsFlags = builtins.map (arch: "build/${arch}/gem5.${build_variant}") isas;

  enableParallelBuilding = true;

  patchPhase = ''
    patchShebangs util/cpt_upgrader.py
  '';

  # Fix build error due to 0 shell width
  configurePhase = ''
    export COLUMNS=80
  '';

  installPhase = ''
    for isa in ${builtins.concatStringsSep " " isas}; do
      mkdir -p $out/bin
      cp build/$isa/gem5.${build_variant} $out/bin/gem5_$isa.${build_variant}
    done
  '';

  meta = {
    description = "The gem5 simulator is a modular platform for computer-system
    architecture research, encompassing system-level architecture as well as
    processor microarchitecture";
    homepage = "https://www.gem5.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [aharris];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
  };
}
