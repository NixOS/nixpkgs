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
  canRunGitGr = stdenv.hostPlatform.emulatorAvailable buildPackages;
  gitGr = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/git-gr";
  pname = "git-gr";
  version = "1.4.6";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "git-gr";
    tag = "v${version}";
    hash = "sha256-ihCwrM8Mt3cBxP5HIXYkvVwKt0CYUE8Ph1S62ztl0tE=";
  };

  buildFeatures = [ "clap_mangen" ];

  cargoHash = "sha256-j/qUWGzsODSsn/dbygN2mYHED3wvUDKEGu7nYcTUm90=";

  env.OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional stdenv.hostPlatform.isLinux pkg-config;

  buildInputs =
    lib.optional stdenv.hostPlatform.isLinux openssl
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  postInstall = lib.optionalString canRunGitGr ''
    manpages=$(mktemp -d)
    ${gitGr} manpages "$manpages"
    for manpage in "$manpages"/*; do
      installManPage "$manpage"
    done

    installShellCompletion --cmd git-gr \
      --bash <(${gitGr} completions bash) \
      --fish <(${gitGr} completions fish) \
      --zsh <(${gitGr} completions zsh)
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
