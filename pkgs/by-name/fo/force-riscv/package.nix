{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python3,
}:
let
  pythonWithPybind = python3.withPackages (py: [ py.pybind11 ]);
in
stdenv.mkDerivation {
  pname = "force-riscv";
  version = "0.9.0-unstable-2023-10-17";

  src = fetchFromGitHub {
    repo = "force-riscv";
    owner = "openhwgroup";
    rev = "5b66fd574c3aef3592cfcb6c6a112a040b127f36";
    hash = "sha256-IDw+W+Ax+/QZp29Oy/o8aD2yhCnYNVaokrr1KBVgnvM=";
  };

  buildInputs = [ pythonWithPybind ];
  nativeBuildInputs = [ makeWrapper ];

  patches = [
    ./fix-includes.patch
    ./remove-pyeval-initthreads.patch
    ./wno-error-range-loop-construct.patch
    ./urbg-static-constexpr-min-max.patch
  ];

  postPatch = ''
    patchShebangs utils/ fpix/utils/

    # Force building with nixpkgs pybind11
    rm -r 3rd_party/inc/pybind11
  '';

  makeFlags = [
    "FORCE_CC=${stdenv.cc.targetPrefix}c++"
    "FORCE_PYTHON_LIB=${pythonWithPybind}/lib"
    "FORCE_PYTHON_INC=${pythonWithPybind}/include/${pythonWithPybind.libPrefix}"
    "PICKY=" # Fix build failure in pybind11 due to -Weffc++
  ];

  enableParallelBuilding = true;

  installPhase =
    let
      paths = [
        "3rd_party/py"
        "utils"
        "utils/builder"
        "utils/builder/test_builder"
        "utils/builder/shared"
        "utils/regression"
      ];

      pythonPath = lib.concatStringsSep ":" (map (p: "$out/${p}") paths);
    in
    ''
      runHook preInstall

      mkdir -p $out/{fpix,riscv,3rd_party}

      # SimApiHANDCAR.so is in bin/ for some reason
      cp -r bin/ py/ $out/
      cp -r fpix/bin/ $out/fpix/

      for binary in $out/{bin/friscv,fpix/bin/fpix_riscv}; do
        wrapProgram $binary \
          --prefix PYTHONPATH : ${pythonPath}
      done

      rm -r utils/handcar/make_area

      cp -r 3rd_party/py/ $out/3rd_party/
      cp -r config/ utils/ $out/
      cp -r riscv/arch_data/ $out/riscv/

      runHook postInstall
    '';

  meta = {
    description = "Instruction sequence generator (ISG) for the RISC-V instruction set architecture";

    homepage = "https://github.com/openhwgroup/force-riscv";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ _3442 ];
  };
}
