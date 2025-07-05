{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  libiconv,
  nix-update-script,
  pkg-config,
  openssl,
}:
let
  pname = "git-gr";
  version = "1.4.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "git-gr";
    tag = "v${version}";
    hash = "sha256-t308Ep27iRvRHSdvVMOrRGVoajBtnTutHAkKbZkO7Wg=";
  };

  buildFeatures = [ "clap_mangen" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-5YHE1NVUcZ5NeOl3Z87l3PVsmlkswhnT83Oi9loJjdM=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs =
    lib.optional stdenv.hostPlatform.isLinux openssl
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/git-gr"
        else
          lib.getExe buildPackages.git-gr;
    in
    ''
      manpages=$(mktemp -d)
      ${exe} manpages "$manpages"
      for manpage in "$manpages"/*; do
        installManPage "$manpage"
      done

      installShellCompletion --cmd git-gr \
        --bash <(${exe} completions bash) \
        --fish <(${exe} completions fish) \
        --zsh <(${exe} completions zsh)
    '';

  meta = {
    homepage = "https://github.com/9999years/git-gr";
    changelog = "https://github.com/9999years/git-gr/releases/tag/v${version}";
    description = "Gerrit CLI client";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers._9999years ];
    mainProgram = "git-gr";
  };

  passthru.updateScript = nix-update-script { };
}
