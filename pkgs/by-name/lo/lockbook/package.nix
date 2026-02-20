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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lockbook";
  version = "26.2.11";

  src = fetchFromGitHub {
    owner = "lockbook";
    repo = "lockbook";
    tag = finalAttrs.version;
    hash = "sha256-LW7BQLnnrTLKee+znznn5r77LHLbk1V7aYjerNQY/5c=";
  };

  cargoHash = "sha256-rTpSVAGvbmHgSsn0IrkR8+VsbIjUX/tRpYUkuskb99w=";

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
})
