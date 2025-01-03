{
  lib,
  buildGoModule,
  fetchpatch,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "journalist";
  version = "1.0.0-unstable-2024-06-15";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = "journalist";
    rev = "93781b1278e271995769f576b74fee794a19de14";
    hash = "sha256-RRo9AEaHJPzN9+oW5kIBUNCPVdFkY2USOIZeUts8P/M=";
  };

  overrideModAttrs = _oldAttrs: {
    patches = [
      # fix go.sum by adding missing module
      # see https://github.com/mrusme/journalist/pull/18
      (fetchpatch {
        name = "fix-go-sum.patch";
        url = "https://github.com/mrusme/journalist/commit/546585222993586057a12ab4e9b38000c537f6cf.patch";
        hash = "sha256-+QZhP/Har5UVi1pvqB6wWY0+xKqP0B8QukCcNlGkqxQ=";
      })
    ];
  };

  vendorHash = "sha256-fEHVc9kRbeeXICWhJshLp9JK/ICBR/RB5SVChJzSXpI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mrusme/journalist/journalistd.VERSION=${version}"
  ];

  meta = {
    description = "RSS aggregator";
    homepage = "https://github.com/mrusme/journalist";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "journalist";
  };
}
