{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  callPackage,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kuna";
  version = "1.980";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Noelo-Lab";
    repo = "kuna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tp0eYpNCVYIo4eHuPC068xAsOHKRRNMdWSjMUfA6u3s=";
  };

  cargoHash = "sha256-YgszQlq5uhmKqbgqpvbX/ox2Jtm3GB8QND61DB/Tohs=";
  cargoRoot = "decompiler";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  env.KUNA_VERSION = finalAttrs.version;

  nativeBuildInputs = [ makeBinaryWrapper ];

  cargoBuildFlags = [
    "-p"
    "kuna-cli"
    "-p"
    "kuna-console"
    "-p"
    "kuna-slacomp"
    "-p"
    "kuna-harness"
  ];

  postBuild =
    let
      slacomp =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "target/${stdenv.hostPlatform.rust.rustcTarget}/release/slacomp"
        else
          "${buildPackages.kuna}/bin/slacomp";
    in
    ''
      ${slacomp} -a specs
    '';

  # Upstream's workspace tests require platform-specific fixtures and toolchains.
  # Check the installed package with a native smoke test instead.
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/kuna/tests
    cp -r specs $out/share/kuna/
    cp -r tests/datatests $out/share/kuna/tests/
    install -Dm644 -t $out/share/licenses/kuna LICENSE NOTICE

    wrapProgram $out/bin/kuna \
      --set-default KUNA_ROOT $out/share/kuna
    for program in decomp_dbg decomp_test_dbg; do
      wrapProgram $out/bin/$program \
        --set-default SLEIGHHOME $out/share/kuna/specs
    done
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    export PATH="$out/bin:$PATH"
    timeout --kill-after=5s 120s bash ${./smoke-test.sh}
    runHook postInstallCheck
  '';

  passthru = {
    web = callPackage ./web.nix { kuna = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Agent-first binary decompiler based on Ghidra";
    homepage = "https://kuna.noelo.org";
    changelog = "https://github.com/Noelo-Lab/kuna/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ connornelson ];
    mainProgram = "kuna";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
