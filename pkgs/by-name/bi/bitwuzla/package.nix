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
  zlib,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitwuzla";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "bitwuzla";
    repo = "bitwuzla";
    rev = finalAttrs.version;
    hash = "sha256-S8CtK8WEehUdOoqOmu5KnoqHFpCGrYWjZKv1st4M7bo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    git
    ninja
    cmake
  ];
  buildInputs = [
    cadical
    cryptominisat
    btor2tools
    symfpu
    gmp
    zlib
  ];

  mesonFlags = [
    # note: the default value for default_library fails to link dynamic dependencies
    # but setting it to shared works even in pkgsStatic
    "-Ddefault_library=shared"
    "-Dcryptominisat=true"

    (lib.strings.mesonEnable "testing" finalAttrs.finalPackage.doCheck)
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
    )

    runHook postInstallCheck
  '';

  meta = {
    description = "SMT solver for fixed-size bit-vectors, floating-point arithmetic, arrays, and uninterpreted functions";
    mainProgram = "bitwuzla";
    homepage = "https://bitwuzla.github.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ symphorien ];
  };
})
