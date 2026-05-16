{
  lib,
  fetchFromGitHub,
  rustPlatform,
  perl,
  kubernetes-helm,
  gitMinimal,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluvio-cli";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "fluvio-community";
    repo = "fluvio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7kGMOAzBGrMOMj4Fyvy9xVwTGEkee5W7JAldbyTV298=";
  };

  cargoHash = "sha256-OAw/nftF63WyE3E+zaVCYYXh37p6HB0ib7WModfXKBA=";

  nativeBuildInputs = [
    # Necessary because of a hard dependency to the openssl-src rust crate
    perl
    kubernetes-helm
    installShellFiles
    # Needed by build.rs scripts
    gitMinimal
  ];

  cargoBuildFlags = [
    "-p"
    "fluvio-cli"
    "-p"
    "fluvio-run"
  ];
  cargoTestFlags = [
    "-p"
    "fluvio-cli"
    "-p"
    "fluvio-run"
  ];

  # Patch to make cargoAuditable work
  postPatch = ''
    substituteInPlace crates/fluvio-cli-common/Cargo.toml \
      --replace-fail '"dep:fluvio-sc-schema"' '"fluvio-sc-schema"'
  '';

  # asset generation
  preBuild = ''
    make -C k8-util/helm package
  '';

  postInstall = ''
    installShellCompletion --cmd fluvio \
      --bash <($out/bin/fluvio completions bash) \
      --fish <($out/bin/fluvio completions fish) \
      --zsh <($out/bin/fluvio completions zsh)
  '';

  meta = {
    description = "Event stream processing for developers";
    homepage = "https://fluvio.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aporro ];
    mainProgram = "fluvio";
    platforms = lib.platforms.unix;
  };
})
