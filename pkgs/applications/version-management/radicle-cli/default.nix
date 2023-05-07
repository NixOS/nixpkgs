{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, cmake
, installShellFiles
, asciidoctor
, DarwinTools
, openssl
, libusb1
, AppKit
, git
, openssh
, testers
, radicle-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "radicle-cli";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "radicle-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LS6zYpMg0LanRL2M8ioGG8Ys07TPT/3hP7geEGehwxg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "automerge-0.0.2" = "sha256-MZ1/rca8ZsEUhd3bhd502PHlBbvqAOtnWFEdp7XWmYE=";
      "automerge-0.1.0" = "sha256-dwbmx3W13oZ1O0Uw3/D5Z0ht1BO1PmVVoWc/tLCm0/4=";
      "cob-0.1.0" = "sha256-ewPJEx7OSr8X6e5QJ4dh2SbzZ2TDa8G4zBR5euBbABo=";
      "libusb1-sys-0.6.2" = "sha256-577ld1xqJkHp2bqALNq5IuZivD8y+VO8vNy9Y+hfq6c=";
      "walletconnect-0.1.0" = "sha256-fdgdhotTYBmWbR4r0OMplOwhYq1C7jkuOdhKASjH+Fs=";
    };
  };

  # Otherwise, there are errors due to the `abigen` macro from `ethers`.
  auditable = false;

  nativeBuildInputs = [
    pkg-config
    cmake
    installShellFiles
    asciidoctor
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    DarwinTools
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libusb1
    AppKit
  ];

  postInstall = ''
    for f in $(find . -name '*.adoc'); do
      mf=''${f%.*}
      asciidoctor --doctype manpage --backend manpage $f -o $mf
      installManPage $mf
    done
  '';

  nativeCheckInputs = [
    git
    openssh
  ];
  preCheck = ''
    eval $(ssh-agent)
  '';

  passthru.tests = {
    version = testers.testVersion { package = radicle-cli; };
  };

  meta = {
    description = "Command-line tooling for Radicle, a decentralized code collaboration network";
    homepage = "https://radicle.xyz";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ amesgen ];
    platforms = lib.platforms.unix;
    mainProgram = "rad";
  };
}
