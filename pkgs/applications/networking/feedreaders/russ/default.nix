{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, xorg
, AppKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "russ";
  version = "unstable-2022-11-19";

  src = fetchFromGitHub {
    owner = "ckampfe";
    repo = "russ";
    rev = "4648f52847b4f90f1c1eb367efccc143c4dca589";
    sha256 = "sha256-78LessfHj/RebxbGNARfzXBVmdGMKyPgtK3F7QCFfC8=";
  };

  cargoSha256 = "sha256-H/lOUGAfSwh4ce06BbJf8tQcTg747hb5/cUzerBaflg=";

  buildInputs = [
    xorg.libxcb
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Security
  ];

  # some tests appear to rely on the network
  doCheck = false;

  meta = with lib; {
    description = "TUI RSS reader with vim-like controls and a local-first, offline-first focus";
    homepage = "https://github.com/ckampfe/russ";
    changelog = "https://github.com/ckampfe/russ/blob/master/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
  };
}
