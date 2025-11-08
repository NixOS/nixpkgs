{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  pkg-config,
  openssl,
  just,
  pandoc,
}:

rustPlatform.buildRustPackage {
  pname = "dogdns";
  version = "unstable-2021-10-07";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "dog";
    rev = "721440b12ef01a812abe5dc6ced69af6e221fad5";
    sha256 = "sha256-y3T0vXg7631FZ4bzcbQjz3Buui/DFxh9LG8BZWwynp0=";
  };

  cargoPatches = [
    # update Cargo.lock to work with openssl 3
    ./openssl3-support.patch
  ];

  cargoHash = "sha256-UY7+AhsVw/p+FDfzJWj9A6VRntceIDCWzJ5Zim8euAE=";

  patches = [
    # remove date info to make the build reproducible
    # remove commit hash to avoid dependency on git and the need to keep `.git`
    ./remove-date-info.patch
  ];

  nativeBuildInputs = [
    installShellFiles
    just
    pandoc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  outputs = [
    "out"
    "man"
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;
  dontUseJustInstall = true;

  postBuild = ''
    just man
  '';

  postInstall = ''
    installShellCompletion completions/dog.{bash,fish,zsh}
    installManPage ./target/man/*.1
  '';

  meta = with lib; {
    description = "Command-line DNS client";
    homepage = "https://dns.lookup.dog";
    license = licenses.eupl12;
    maintainers = [ ];
    mainProgram = "dog";
  };
}
