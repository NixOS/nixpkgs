{
  buildGoModule,
  fetchFromSourcehut,
  lib,
  scdoc,
  installShellFiles,
}:
buildGoModule {
  pname = "ratt";
  version = "0-unstable-2025-03-10";

  src = fetchFromSourcehut {
    owner = "~ghost08";
    repo = "ratt";
    rev = "7433a875fb5d8f614e8630cd50b3c9580ef931ce";
    hash = "sha256-u4rad2+SN1yMUjyDZgZo3XDQddICWfa35piYe6437MU=";
  };

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  proxyVendor = true;
  vendorHash = "sha256-W1snHDmy6Pg35jYfNmV5DpRpQpp9Ju0JjzwMRYGoqXY==";

  # tests try to access the internet to scrape websites
  doCheck = false;

  postInstall = ''
    scdoc < doc/ratt.1.scd > doc/ratt.1
    installManPage doc/ratt.1

    scdoc < doc/ratt.5.scd > doc/ratt.5
    installManPage doc/ratt.5
  '';

  meta = with lib; {
    description = "Tool for converting websites to rss/atom feeds";
    homepage = "https://git.sr.ht/~ghost08/ratt";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
    mainProgram = "ratt";
  };
}
