{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitwuzla";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bitwuzla";
    repo = "bitwuzla";
    rev = finalAttrs.version;
    hash = "sha256-Th2YkynOzxcZB4xqyH8D3QqcuQzkWYAd+hYfZ5OmrJ0=";
  };

  patches = [
    # fix tests https://github.com/bitwuzla/bitwuzla/issues/176
    # remove on next release
    (fetchpatch {
      url = "https://github.com/bitwuzla/bitwuzla/commit/d090786042aaceef6d39cf55c22daf5fb74457f5.patch";
      hash = "sha256-c3u2oL1Fhg7dvVlA7pfPMTW5wgWigbxuegz5wHFZquY=";
    })
    # fix tests https://github.com/bitwuzla/bitwuzla/issues/176
    # remove on next release
    (fetchpatch {
      url = "https://github.com/bitwuzla/bitwuzla/commit/bdc83e1f06ce2851c86cce16a604c3c47b254d2d.patch";
      hash = "sha256-i9u/11h+Ye3NHI+rkDLISbG1DYGCBqORL1nEEJryYzA=";
    })
    # fix tests https://github.com/bitwuzla/bitwuzla/issues/176
    # remove on next release
    (fetchpatch {
      url = "https://github.com/bitwuzla/bitwuzla/commit/a623930e3c12c3932301bd68c54590a15e6bfa69.patch";
      hash = "sha256-uua+wSvK621cmNLaKrRgjb0aNL/b4254lQMtAiGU9KM=";
    })
  ];

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
    kissat
    aiger
  ];

  mesonFlags = [
    # note: the default value for default_library fails to link dynamic dependencies
    # but setting it to shared works even in pkgsStatic
    "-Ddefault_library=shared"
    "-Dcryptominisat=true"
    "-Dkissat=true"
    "-Daiger=true"

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
    $out/bin/bitwuzla -S kissat -m file.smt2 | tee /dev/stderr | grep $needle;
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
