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
}:
let
  canRunGitGr = stdenv.hostPlatform.emulatorAvailable buildPackages;
  gitGr = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/git-gr";
  pname = "git-gr";
  version = "1.0.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "9999years";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hvK4reFR60q9mw3EdNLav9VMr4H6Zabv1N1D/5AAKuQ=";
  };

  buildFeatures = [ "clap_mangen" ];

  cargoHash = "sha256-efoRiPWugz955MflIS81Nie7Oq5Y4u5CI+/el8fJVl0=";

  nativeBuildInputs =
    [ installShellFiles ]
    ++ lib.optionals stdenv.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.CoreServices
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
