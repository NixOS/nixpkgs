{ notmuch
, lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "notmuch-mailmover";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "michaeladler";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-12eDCqer13GJS0YjJDleJbkP4o7kZfof6HlLG06qZW0=";
  };

  cargoHash = "sha256-B5VSkhY4nNXSG2SeCl22pSkl6SXEEoYj99wEsNhs/bQ=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ notmuch ];

  postInstall = ''
    installManPage share/notmuch-mailmover.1
    installShellCompletion --cmd notmuch-mailmover \
      --bash share/notmuch-mailmover.bash \
      --fish share/notmuch-mailmover.fish \
      --zsh share/_notmuch-mailmover
  '';

  meta = with lib; {
    description = "Application to assign notmuch tagged mails to IMAP folders";
    homepage = "https://github.com/michaeladler/notmuch-mailmover/";
    license = licenses.asl20;
    maintainers = with maintainers; [ michaeladler archer-65 ];
    platforms = platforms.all;
  };
}
