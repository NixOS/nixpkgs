{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "kepubify";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "pgaskin";
    repo = "kepubify";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-H6W+C5twXit7Z9hLIJKAftbnvYDA9HAb9tR6yeQGRKI=";
  };

  vendorHash = "sha256-QOMLwDDvrDQAaK4M4QhBFTGD1CzblkDoA3ZqtCoRHtQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  excludedPackages = [ "kobotest" ];

  meta = {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zowoq ];
  };
})
