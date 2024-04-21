{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  libiconv,
  darwin,
  nix-update-script,
  pkg-config,
  openssl,
}:
let
  canRunGitGr = stdenv.hostPlatform.emulatorAvailable buildPackages;
  gitGr = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/git-gr";
  pname = "git-gr";
  version = "1.2.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5Pr1z+RmY92cfT7KtFnUKpzhniUN6RjDKBekWiYCCuU=";
  };

  buildFeatures = [ "clap_mangen" ];

  cargoHash = "sha256-5JLTSBBTPGUbuqUql/cMJKBLlO2uzuU1EDhfScaeCUg=";

  OPENSSL_NO_VENDOR = true;

  nativeBuildInputs =
    [installShellFiles]
    ++ lib.optional stdenv.isLinux pkg-config;

  buildInputs =
    lib.optional stdenv.isLinux openssl
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.SystemConfiguration
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

  meta = with lib; {
    homepage = "https://github.com/9999years/git-gr";
    description = "A Gerrit CLI client";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
    mainProgram = "git-gr";
  };

  passthru.updateScript = nix-update-script { };
}
