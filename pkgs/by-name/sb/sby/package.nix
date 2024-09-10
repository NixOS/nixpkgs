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
  btor2tools,
  python3Packages,
  nix-update-script,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ click ]);
in

stdenv.mkDerivation rec {
  pname = "sby";
  version = "0.45";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "sby";
    rev = "yosys-${version}";
    hash = "sha256-HRQ5ZL0w3GLUySTFekE/T/VlxJLFIQQr0bW8l7rp/zs=";
  };

  nativeBuildInputs = [ bash ];
  buildInputs = [
    pythonEnv
    yosys
    boolector
    yices
    z3
    aiger
    btor2tools
  ];

  postPatch = ''
    patchShebangs docs/source/conf.py \
      docs/source/conf.diff \
      tests/autotune/*.sh \
      tests/keepgoing/*.sh \
      tests/junit/*.sh

    # Fix up Yosys imports
    substituteInPlace sbysrc/sby.py \
      --replace-fail "##yosys-sys-path##" \
                "sys.path += [p + \"/share/yosys/python3/\" for p in [\"$out\", \"${yosys}\"]]"

    # Fix various executable references
    substituteInPlace sbysrc/sby_core.py \
      --replace-fail '"/usr/bin/env", "bash"' '"${bash}/bin/bash"' \
      --replace-fail ', "btormc"'             ', "${boolector}/bin/btormc"' \
      --replace-fail ', "aigbmc"'             ', "${aiger}/bin/aigbmc"'

    substituteInPlace sbysrc/sby_core.py \
      --replace-fail '##yosys-program-prefix##' '"${yosys}/bin/"'

    substituteInPlace sbysrc/sby.py \
      --replace-fail '/usr/bin/env python3' '${pythonEnv}/bin/python'
    substituteInPlace sbysrc/sby_autotune.py \
      --replace-fail '["btorsim", "--vcd"]' '["${btor2tools}/bin/btorsim", "--vcd"]'
    substituteInPlace tests/make/required_tools.py \
      --replace-fail '["btorsim", "--vcd"]' '["${btor2tools}/bin/btorsim", "--vcd"]'
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/yosys/python3

    cp sbysrc/sby_*.py $out/share/yosys/python3/
    cp sbysrc/sby.py $out/bin/sby

    chmod +x $out/bin/sby
    runHook postInstall
  '';

  doCheck = true;

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
    description = "SymbiYosys, a front-end for Yosys-based formal verification flows";
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
