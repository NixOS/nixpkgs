{
  buildPackages,
  cmake,
  fetchFromGitHub,
  lib,
  ninja,
  stdenv,
  testers,
  quick-lint-js,
}:

let
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "quick-lint";
    repo = "quick-lint-js";
    rev = version;
    hash = "sha256-L2LCRm1Fsg+xRdPc8YmgxDnuXJo92nxs862ewzObZ3I=";
  };

  quick-lint-js-build-tools = buildPackages.stdenv.mkDerivation {
    pname = "quick-lint-js-build-tools";
    inherit version src;

    nativeBuildInputs = [
      cmake
      ninja
    ];
    doCheck = false;

    cmakeFlags = [
      "-DQUICK_LINT_JS_ENABLE_BUILD_TOOLS=ON"
      # Temporary workaround for https://github.com/NixOS/nixpkgs/pull/108496#issuecomment-1192083379
      "-DCMAKE_SKIP_BUILD_RPATH=ON"
    ];
    ninjaFlags = "quick-lint-js-build-tools";

    installPhase = ''
      runHook preInstall
      cmake --install . --component build-tools
      runHook postInstall
    '';
  };
in
stdenv.mkDerivation {
  pname = "quick-lint-js";
  inherit version src;

  nativeBuildInputs = [
    cmake
    ninja
  ];
  doCheck = true;

  cmakeFlags = [
    "-DQUICK_LINT_JS_USE_BUILD_TOOLS=${quick-lint-js-build-tools}/bin"
    # Temporary workaround for https://github.com/NixOS/nixpkgs/pull/108496#issuecomment-1192083379
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  passthru.tests = {
    version = testers.testVersion { package = quick-lint-js; };
  };

  meta = with lib; {
    description = "Find bugs in Javascript programs";
    mainProgram = "quick-lint-js";
    homepage = "https://quick-lint-js.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ratsclub ];
    platforms = platforms.all;
  };

  # Expose quick-lint-js-build-tools to nix repl as quick-lint-js.build-tools.
  passthru.build-tools = quick-lint-js-build-tools;
}
