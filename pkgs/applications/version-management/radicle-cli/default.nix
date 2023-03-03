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

  cargoSha256 = "sha256-o7ahnV7NnvzKxXb7HdNqKcxekshOtKanYKb0Sy15mhs=";

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
