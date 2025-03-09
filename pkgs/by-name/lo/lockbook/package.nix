{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "lockbook";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "lockbook";
    repo = "lockbook";
    rev = "refs/tags/${version}";
    hash = "sha256-hqBjA/6MWlhVjV4m+cIcnoRTApHuzbPzivMsaQHfRcc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+M+wL26KDbLKhcujPyWAsTlXwLrQVCUbTnnu/7sXul4=";

  doCheck = false; # there are no cli tests
  cargoBuildFlags = [
    "--package"
    "lockbook-cli"
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
