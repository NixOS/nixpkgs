{ notmuch
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "notmuch-mailmover";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "michaeladler";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-b+6vQ7m49+9RQ+GA75VgOAJej/2zeu5JAje/OazsEsk=";
  };

  cargoHash = "sha256-qHSmfR5iUBXq8OQJkGCVA4JnExXisN2OIAVKiVMUaZo=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ notmuch ];

  postInstall = ''
    installManPage share/notmuch-mailmover.1.gz
    installShellCompletion --cmd notmuch-mailmover \
      --bash share/notmuch-mailmover.bash \
      --fish share/notmuch-mailmover.fish \
      --zsh share/_notmuch-mailmover
  '';

  meta = with lib; {
    description = "Application to assign notmuch tagged mails to IMAP folders";
    mainProgram = "notmuch-mailmover";
    homepage = "https://github.com/michaeladler/notmuch-mailmover/";
    license = licenses.asl20;
    maintainers = with maintainers; [ michaeladler archer-65 ];
    platforms = platforms.all;
  };
}
