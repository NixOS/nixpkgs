{
  stdenv,
  fetchFromGitHub,
  lib,
  python3,
  meson,
  ninja,
  git,
  btor2tools,
  symfpu,
  gtest,
  gmp,
  cadical,
  cryptominisat,
  kissat,
  zlib,
  pkg-config,
  cmake,
  aiger,
  mpfr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitwuzla";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "bitwuzla";
    repo = "bitwuzla";
    tag = finalAttrs.version;
    hash = "sha256-eRIvcRHNH88uopWRkgQS2hOYaCKWv1JbqCDMrbp8fOw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    pkg-config
    git
    ninja
    cmake
  ];

  buildInputs =
    let
      # these patches are required to fix a linking error where kissat and cadical conflict on some kitten symbols
      cadical' = cadical.overrideAttrs (old: {
        postPatch =
          (old.postPatch or "")
          # sh
          + ''
            cp ${finalAttrs.src}/subprojects/packagefiles/cadical/src/kitten_prefix.h src
            for i in ${finalAttrs.src}/subprojects/packagefiles/cadical/*.patch; do
              patch -p1 < "$i"
            done
          '';
      });
    in
    [
      cadical'
      cryptominisat
      btor2tools
      symfpu
      gmp
      zlib
      kissat
      aiger
      mpfr
    ];

  mesonFlags = [
    # note: the default value for default_library fails to link dynamic dependencies
    # but setting it to shared works even in pkgsStatic
    "-Ddefault_library=shared"
    "-Dcryptominisat=true"
    "-Dkissat=true"
    "-Daiger=true"

    (lib.strings.mesonEnable "testing" finalAttrs.finalPackage.doCheck)

    "-Dmimalloc=disabled"
  ];

  nativeCheckInputs = [ python3 ];
  checkInputs = [ gtest ];
  # two tests fail on darwin
  doCheck = stdenv.hostPlatform.isLinux;
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export needle=11011110101011011011111011101111

    cat > file.smt2 <<EOF
    (declare-fun a () (_ BitVec 32))
    (assert (= a #b$needle))
    (check-sat)
    (get-model)
    EOF

    # check each backend
    (
    set -euxo pipefail;
    $out/bin/bitwuzla -S cms -j 3 -m file.smt2 | tee /dev/stderr | grep $needle;
    $out/bin/bitwuzla -S cadical -m file.smt2 | tee /dev/stderr | grep $needle;
    $out/bin/bitwuzla -S kissat -m file.smt2 | tee /dev/stderr | grep $needle;
    )

    runHook postInstallCheck
  '';

  meta = {
    description = "SMT solver for fixed-size bit-vectors, floating-point arithmetic, arrays, and uninterpreted functions";
    mainProgram = "bitwuzla";
    homepage = "https://bitwuzla.github.io";
    changelog = "https://github.com/bitwuzla/bitwuzla/blob/${finalAttrs.version}/NEWS.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ symphorien ];
  };
})
