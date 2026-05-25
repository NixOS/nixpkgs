{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

let
  emulatorAvailable = stdenv.hostPlatform.emulatorAvailable buildPackages;
  emulator = stdenv.hostPlatform.emulator buildPackages;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npingler";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "npingler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vEaIhHN0nNmZbl2oUZzV0s9TyZauq0rY3ACJW6sw2xc=";
  };

  cargoHash = "sha256-xwhdlotwr9lyha4nn+meQnHE3/Dge+lT1QPHv+LWiv0=";

  buildFeatures = [ "clap_mangen" ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString emulatorAvailable ''
    manpages=$(mktemp -d)
    ${emulator} $out/bin/npingler util generate-man-pages "$manpages"
    for manpage in "$manpages"/*; do
      installManPage "$manpage"
    done

    installShellCompletion --cmd npingler \
      --bash <(${emulator} $out/bin/npingler util generate-completions bash) \
      --fish <(${emulator} $out/bin/npingler util generate-completions fish) \
      --zsh  <(${emulator} $out/bin/npingler util generate-completions zsh)
  '';

  meta = {
    description = "Nix profile manager for use with npins";
    homepage = "https://github.com/9999years/npingler";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "npingler";
  };

  passthru.updateScript = nix-update-script { };
})
