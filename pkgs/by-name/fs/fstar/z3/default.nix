{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  z3,
}:

let
  z3' = z3.override { pythonBindings = false; };

  mkZ3 =
    version: hash:
    z3'.overrideAttrs {
      inherit version;
      patches = [ (./. + "/${version}.patch") ];
      postPatch = "";
      src = fetchFromGitHub {
        owner = "Z3Prover";
        repo = "z3";
        rev = "z3-${version}";
        inherit hash;
      };
    };

  withLegacyFixes =
    solver:
    solver.overrideAttrs (prev: {
      # Older releases use an uppercase Z3 tag prefix.
      src = prev.src.override { rev = "Z3-${prev.version}"; };

      cmakeFlags = map (lib.replaceStrings [ "-DZ3_" ] [ "-D" ]) prev.cmakeFlags ++ [
        (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
      ];

      # The API generator imports distutils even without Python bindings.
      postPatch = (prev.postPatch or "") + ''
        substituteInPlace scripts/mk_util.py \
          --replace-fail "distutils.sysconfig.get_python_lib()" "sysconfig.get_path('purelib')" \
          --replace-fail "distutils.sysconfig" "sysconfig"
      '';

      meta = prev.meta // {
        pkgConfigModules = [ ];
      };
    });

  # Keep the exact versions distributed with this F* release.
  # https://github.com/NixOS/nixpkgs/pull/374917#issuecomment-2661497006
  solvers = {
    z3_4_8_5 = withLegacyFixes (mkZ3 "4.8.5" "sha256-ytG5O9HczbIVJAiIGZfUXC/MuYH7d7yLApaeTRlKXoc=");
    z3_4_13_3 = mkZ3 "4.13.3" "sha256-odwalnF00SI+sJGHdIIv4KapFcfVVKiQ22HFhXYtSvA=";
    z3_4_15_3 = mkZ3 "4.15.3" "sha256-Lw037Z0t0ySxkgMXkbjNW5CB4QQLRrrSEBsLJqiomZ4=";
    z3_5_3_0 = mkZ3 "5.3.0" "sha256-K0KTI8ZpvvYCF9ITxVTbdtqlalFFjtYcyog/Sy1kRV8=";
  };
in
stdenvNoCC.mkDerivation {
  name = "fstar-z3";
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ${lib.concatMapStringsSep "\n" (solver: ''
      ln -s ${lib.getExe solver} $out/bin/z3-${solver.version}
    '') (builtins.attrValues solvers)}
    runHook postInstall
  '';

  passthru = solvers;
}
