{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "feed2imap-go";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "Necoro";
    repo = "feed2imap-go";
    rev = "v${version}";
    sha256 = "sha256-LMtuGrNRVG3/2cgZFS7YlVmassbWDhH/nQgPh08NmpA=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Necoro/feed2imap-go/pkg/version.version=${version}"
    "-X github.com/Necoro/feed2imap-go/pkg/version.commit=nixpkgs"
  ];

  vendorHash = "sha256-3J9fd/ogClQ+1a2ORahwf+JwkC4b1+pR1vdVjwLutoY=";

  # The print-cache tool is not an end-user tool (https://github.com/Necoro/feed2imap-go/issues/94)
  postInstall = ''
    rm -f $out/bin/print-cache
  '';

  meta = with lib; {
    description = "Uploads rss feeds as e-mails onto an IMAP server";
    mainProgram = "feed2imap-go";
    homepage = "https://github.com/Necoro/feed2imap-go";
    license = licenses.gpl2;
    maintainers = with maintainers; [ nomeata ];
  };
}
