{ lib
, stdenv
, fetchgit
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
  version = "1.0.0-rc8";

  src = fetchgit {
    url = "https://seed.radicle.xyz/z3gqcJUoA1n9HaHKufZs5FCSGazv5.git";
    rev = "0d880e12e151979ab676083f779599b8f14b69fb";
    hash = "sha256-F2n7ui0EgXK8fT76M14RVhXXGeRYub+VpH+puDUJ1pQ=";
  };

  cargoSha256 = "sha256-Ej9cxuHxiQDwCXOwcIyfCau9Thhz+hf3IevN6F4rDjM=";

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
