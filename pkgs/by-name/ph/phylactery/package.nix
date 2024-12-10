{
  lib,
  buildGoModule,
  fetchzip,
  nixosTests,
}:

buildGoModule rec {
  pname = "phylactery";
  version = "0.2.0";

  src = fetchzip {
    url = "https://trong.loang.net/phylactery/snapshot/phylactery-${version}.tar.gz";
    hash = "sha256-UokK6rVjpzbcKOkZteo5kU7rFMm1meBUM4bkYAYM8rI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.phylactery = nixosTests.phylactery;

  meta = with lib; {
    description = "Old school comic web server";
    mainProgram = "phylactery";
    homepage = "https://trong.loang.net/phylactery/about";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ McSinyx ];
    platforms = platforms.all;
  };
}
