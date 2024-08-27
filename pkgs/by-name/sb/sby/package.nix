{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  python3,
  yosys,
  yices,
  boolector,
  z3,
  aiger,
  python3Packages,
  nix-update-script,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ click ]);
in

stdenv.mkDerivation rec {
  pname = "sby";
  version = "0.44";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "sby";
    rev = "yosys-${version}";
    hash = "sha256-/oDbbdZuWPdg0Xrh+c4i283vML9QTfyWVu8kryb4WaE=";
  };

  nativeBuildInputs = [ bash ];
  buildInputs = [
    pythonEnv
    yosys
    boolector
    yices
    z3
    aiger
  ];

  patchPhase = ''
    patchShebangs .

    # Fix up Yosys imports
    substituteInPlace sbysrc/sby.py \
      --replace "##yosys-sys-path##" \
                "sys.path += [p + \"/share/yosys/python3/\" for p in [\"$out\", \"${yosys}\"]]"

    # Fix various executable references
    substituteInPlace sbysrc/sby_core.py \
      --replace '"/usr/bin/env", "bash"' '"${bash}/bin/bash"' \
      --replace ', "btormc"'             ', "${boolector}/bin/btormc"' \
      --replace ', "aigbmc"'             ', "${aiger}/bin/aigbmc"'

    substituteInPlace sbysrc/sby_core.py \
      --replace '##yosys-program-prefix##' '"${yosys}/bin/"'

    substituteInPlace sbysrc/sby.py \
      --replace '/usr/bin/env python3' '${pythonEnv}/bin/python'
  '';

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/bin $out/share/yosys/python3

    cp sbysrc/sby_*.py $out/share/yosys/python3/
    cp sbysrc/sby.py $out/bin/sby

    chmod +x $out/bin/sby
  '';

  doCheck = true;
  nativeCheckInputs = [
    pythonEnv
    yosys
    boolector
    yices
    z3
    aiger
  ];
  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "yosys-([0-9].*)"
    ];
  };

  meta = {
    description = "SymbiYosys (sby) -- Front-end for Yosys-based formal verification flows";
    homepage = "https://symbiyosys.readthedocs.io/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      thoughtpolice
      rcoeurjoly
    ];
    mainProgram = "sby";
    platforms = lib.platforms.all;
  };
}
