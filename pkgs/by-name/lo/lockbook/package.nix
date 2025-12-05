{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nfs-utils ? null, # macOS doesn't need this
  makeBinaryWrapper,
}:
let
  inherit (stdenv.hostPlatform) isLinux;
in
rustPlatform.buildRustPackage rec {
  pname = "lockbook";
  version = "25.12.1";

  src = fetchFromGitHub {
    owner = "lockbook";
    repo = "lockbook";
    tag = version;
    hash = "sha256-Of3RjpBYzIW0ZUWJQxwVB+/NfCJUttEU28UvE5AA8OI=";
  };

  cargoHash = "sha256-uruy8BCPAu3kK2DrxX9BsnDHC2igabBdLGfwVLlhNIs=";

  doCheck = false; # there are no cli tests
  cargoBuildFlags = [
    "--package"
    "lockbook"
  ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals isLinux [ makeBinaryWrapper ];

  postFixup = lib.optionalString isLinux ''
    wrapProgram $out/bin/lockbook \
      --prefix PATH : "${lib.makeBinPath [ nfs-utils ]}"
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --bash --name lockbook.bash <($out/bin/lockbook completions bash)
    installShellCompletion --zsh --name _lockbook <($out/bin/lockbook completions zsh)
    installShellCompletion --fish --name lockbook.fish <($out/bin/lockbook completions fish)
  '';

  meta = {
    description = "Private, polished note-taking platform";
    longDescription = ''
      Write notes, sketch ideas, and store files in one secure place.
      Share seamlessly, keep data synced, and access it on any
      platform—even offline. Lockbook encrypts files so even we
      can’t see them, but don’t take our word for it:
      Lockbook is 100% open-source.
    '';
    homepage = "https://lockbook.net";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.all;
    changelog = "https://github.com/lockbook/lockbook/releases";
    maintainers = [ lib.maintainers.parth ];
  };
}
