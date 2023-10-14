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
, testers
, radicle-cli
}:

rustPlatform.buildRustPackage {
  pname = "radicle-cli";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "radicle-dev";
    repo = "heartwood";
    rev = "c3e11057ad933aeef27ffe091be2048557cad469";
    sha256 = "sha256-ZuNtxy5k2TBDjn/aQckRvk5JmK4eUF6bFCzf2PgnFUs=";
  };

  cargoSha256 = "sha256-duN/6/S93EZaExsPS5eWxpaFvvSKuwxgHeZDocPkZEQ=";

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

  # only radicle-cli::commands and radicle-node tests need to be disabled as they require network
  # however is doesn't seem possible
  # to pass "-E not ((package(radicle-cli) and binary(commands)) or (package(radicle-node)))"
  # to cargo nextest as shell quoting keeps breaking the argument being passed.
  doCheck = false;

  passthru.tests = {
    version = testers.testVersion { package = radicle-cli; };
  };

  meta = {
    description = "Command-line tooling for Radicle, a decentralized code collaboration network";
    homepage = "https://radicle.xyz";
    license = [ lib.licenses.mit lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ amesgen ];
    platforms = lib.platforms.unix;
    mainProgram = "rad";
  };
}
