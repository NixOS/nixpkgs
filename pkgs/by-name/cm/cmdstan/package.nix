{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  stanc,
  buildPackages,
  runtimeShell,
  runCommandCC,
  cmdstan,
}:

stdenv.mkDerivation rec {
  pname = "cmdstan";
  version = "2.35.0";

  src = fetchFromGitHub {
    owner = "stan-dev";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-bmzkXbR4KSnpfXjs2MAx8mbNSbNrIWDP/O8S+JGWrcg=";
  };

  postPatch = ''
    substituteInPlace stan/lib/stan_math/make/libraries \
      --replace "/usr/bin/env bash" "bash"
  '';

  nativeBuildInputs = [
    python3
    stanc
  ];

  preConfigure =
    ''
      patchShebangs test-all.sh runCmdStanTests.py stan/
    ''
    # Fix inclusion of hardcoded paths in PCH files, by building in the store.
    + ''
      mkdir -p $out/opt
      cp -R . $out/opt/cmdstan
      cd $out/opt/cmdstan
      mkdir -p bin
      ln -s ${buildPackages.stanc}/bin/stanc bin/stanc
    '';

  makeFlags =
    [
      "build"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "arch=${stdenv.hostPlatform.darwinArch}"
    ];

  # Disable inclusion of timestamps in PCH files when using Clang.
  env.CXXFLAGS = lib.optionalString stdenv.cc.isClang "-Xclang -fno-pch-timestamp";

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s $out/opt/cmdstan/bin/stanc $out/bin/stanc
    ln -s $out/opt/cmdstan/bin/stansummary $out/bin/stansummary
    cat > $out/bin/stan <<EOF
    #!${runtimeShell}
    make -C $out/opt/cmdstan "\$(realpath "\$1")"
    EOF
    chmod a+x $out/bin/stan

    runHook postInstall
  '';

  passthru.tests = {
    test = runCommandCC "cmdstan-test" { } ''
      cp -R ${cmdstan}/opt/cmdstan cmdstan
      chmod -R +w cmdstan
      cd cmdstan
      ./runCmdStanTests.py -j$NIX_BUILD_CORES src/test/interface
      touch $out
    '';
  };

  meta = with lib; {
    description = "Command-line interface to Stan";
    longDescription = ''
      Stan is a probabilistic programming language implementing full Bayesian
      statistical inference with MCMC sampling (NUTS, HMC), approximate Bayesian
      inference with Variational inference (ADVI) and penalized maximum
      likelihood estimation with Optimization (L-BFGS).
    '';
    homepage = "https://mc-stan.org/interfaces/cmdstan.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
}
