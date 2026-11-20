{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  python3,
  yosys,
  yices,
  z3,
  aiger,
  btor2tools,
  nix-update-script,
}:

let
  pythonDeps = ps: with ps; [ click ];
  pythonEnv = python3.withPackages pythonDeps;
  checkPythonEnv = python3.withPackages (ps: pythonDeps ps ++ [ ps.xmlschema ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "sby";
  version = "0.69";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "sby";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BNxSMDtfnNrIOrXYxXD7XAHNJUGifEFRYrYpyteAMHQ=";
  };

  postPatch = ''
    patchShebangs --build \
      docs/source/conf.py \
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
      --replace-fail '"/usr/bin/env", "bash"' '"${lib.getExe bash}"' \
      --replace-fail ', "aigbmc"'             ', "${lib.getExe' aiger "aigbmc"}"'

    substituteInPlace sbysrc/sby_core.py \
      --replace-fail '##yosys-program-prefix##' '"${yosys}/bin/"'

    substituteInPlace sbysrc/sby.py \
      --replace-fail '/usr/bin/env python3' '${pythonEnv}/bin/python'
    substituteInPlace sbysrc/sby_autotune.py \
      --replace-fail '["btorsim", "--vcd"]' '["${lib.getExe' btor2tools "btorsim"}", "--vcd"]'
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

  nativeCheckInputs = [
    checkPythonEnv
    yosys
    yices
    z3
    aiger
    btor2tools
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SymbiYosys, a front-end for Yosys-based formal verification flows";
    homepage = "https://symbiyosys.readthedocs.io/";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      thoughtpolice
      carlossless
    ];
    mainProgram = "sby";
    platforms = lib.platforms.all;
  };
})
