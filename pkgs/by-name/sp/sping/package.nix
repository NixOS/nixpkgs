{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  darwin,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sping";
  version = "1.6.0";

  __structuredAttrs = true;
  # The tests connect to TCP listeners on the loopback address.
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "LambdaBytes";
    repo = "sping";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ewttcciX/CYTqQFFaTpCHAzcDT/N1S3sLMew/luYkas=";
  };

  cargoHash = "sha256-25JrJrMyVx3GGC7PzKaF3bSR3dcr5zNrrfqCyh4Hk+8=";

  nativeBuildInputs = [ installShellFiles ];

  # The Darwin build sandbox does not let /sbin/ifconfig run, and a test
  # lists the interfaces with it: use the one from nixpkgs.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/context/iface.rs --replace-fail /sbin/ifconfig ${lib.getExe' darwin.network_cmds "ifconfig"}
  '';

  # build.rs writes the man page and the shell completions to
  # SPING_ASSETS_DIR, an absolute path ($OUT_DIR/assets otherwise).
  preBuild = ''
    export SPING_ASSETS_DIR="$PWD/target/assets"
  '';

  postInstall = ''
    installManPage target/assets/man/sping.1
    installShellCompletion --bash target/assets/completions/sping.bash
    installShellCompletion --zsh target/assets/completions/_sping
    installShellCompletion --fish target/assets/completions/sping.fish
  '';

  meta = {
    description = "Terminal-native real-time connectivity monitor with network context diagnostics";
    homepage = "https://github.com/LambdaBytes/sping";
    changelog = "https://github.com/LambdaBytes/sping/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "sping";
    maintainers = [ lib.maintainers.LambdaBytes ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
