{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "lockbook";
  version = "0.9.27";

  src = fetchFromGitHub {
    owner = "lockbook";
    repo = "lockbook";
    tag = version;
    hash = "sha256-D194oIp6EE0Ub0+4iw4SlTxoyJ9I8xZa67TTh241BvE=";
  };

  cargoHash = "sha256-KTT4z9lSrxpbCAyEccFMdqrCJKNYhv/8Jb6HeKzJYHs=";

  doCheck = false; # there are no cli tests
  cargoBuildFlags = [
    "--package"
    "lockbook"
  ];

  nativeBuildInputs = [ installShellFiles ];
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
