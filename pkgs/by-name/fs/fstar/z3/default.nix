{
  fetchFromGitHub,
  fetchpatch,
  lib,
  replaceVars,
  stdenvNoCC,
  z3,
}:

let
  z3' = z3.override { useCmakeBuild = false; };

  # fstar has a pretty hard dependency on certain z3 patch versions.
  # https://github.com/FStarLang/FStar/issues/3689#issuecomment-2625073641
  # We need to package all the Z3 versions it prefers here.
  fstarNewZ3Version = "4.13.3";
  fstarNewZ3 =
    if z3'.version == fstarNewZ3Version then
      z3'
    else
      z3'.overrideAttrs (final: rec {
        version = fstarNewZ3Version;
        src = fetchFromGitHub {
          owner = "Z3Prover";
          repo = "z3";
          rev = "z3-${version}";
          hash = "sha256-odwalnF00SI+sJGHdIIv4KapFcfVVKiQ22HFhXYtSvA=";
        };
      });

  fstarOldZ3Version = "4.8.5";
  fstarOldZ3 =
    if z3'.version == fstarOldZ3Version then
      z3'
    else
      z3'.overrideAttrs (prev: rec {
        version = fstarOldZ3Version;
        src = fetchFromGitHub {
          owner = "Z3Prover";
          repo = "z3";
          rev = "Z3-${version}"; # caps matter
          hash = "sha256-ytG5O9HczbIVJAiIGZfUXC/MuYH7d7yLApaeTRlKXoc=";
        };
        patches =
          let
            static-matrix-patch = fetchpatch {
              # clang / gcc fixes. fixes typos in some member names
              name = "gcc-15-fixes.patch";
              url = "https://github.com/Z3Prover/z3/commit/2ce89e5f491fa817d02d8fdce8c62798beab258b.patch";
              includes = [ "src/@dir@/lp/static_matrix.h" ];
              stripLen = 3;
              extraPrefix = "src/@dir@/";
              hash = "sha256-+H1/VJPyI0yq4M/61ay8SRCa6OaoJ/5i+I3zVTAPUVo=";
            };

            # replace @dir@ in the path of the given list of patches
            fixupPatches = dir: map (patch: replaceVars patch { dir = dir; });
          in
          prev.patches or [ ]
          ++ fixupPatches "util" [
            ./lower-bound-typo.diff
            static-matrix-patch
            ./tail-matrix.diff
          ]
          ++ [
            ./4-8-5-typos.diff
          ];

        postPatch =
          let
            python = lib.findFirst (pkg: lib.hasPrefix "python" pkg.pname) null prev.nativeBuildInputs;
          in

          assert python != null;

          prev.postPatch or ""
          +
            lib.optionalString
              ((lib.versionAtLeast python.version "3.12") && (lib.versionOlder version "4.8.14"))
              ''
                # See https://github.com/Z3Prover/z3/pull/5729. This is a specialization of this patch for 4.8.5.
                for file in scripts/mk_util.py src/api/python/CMakeLists.txt; do
                  substituteInPlace "$file" \
                    --replace-fail "distutils.sysconfig.get_python_lib()" "sysconfig.get_path('purelib')" \
                    --replace-fail "distutils.sysconfig" "sysconfig"
                done
              '';

      });
in
stdenvNoCC.mkDerivation {
  name = "fstar-z3";
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${lib.getExe fstarNewZ3} $out/bin/z3-${lib.escapeShellArg fstarNewZ3.version}
    ln -s ${lib.getExe fstarOldZ3} $out/bin/z3-${lib.escapeShellArg fstarOldZ3.version}
  '';

  passthru = rec {
    new = fstarNewZ3;
    "z3_${lib.replaceStrings [ "." ] [ "_" ] fstarNewZ3.version}" = new;

    old = fstarOldZ3;
    "z3_${lib.replaceStrings [ "." ] [ "_" ] fstarOldZ3.version}" = old;
  };
}
