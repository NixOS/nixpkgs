{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "fission";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bPGdUllKBkAA1cURBzuVjggHN1Phdyx7Hu6/HdqTg6c=";
  };

  vendorHash = "sha256-OIu08Wl5hcTTvMzfCcYz4JUqqhlTIDwxtdgbA5mXoRA=";

  ldflags = [
    "-s"
    "-w"
    "-X info.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/fission-cli" ];

  postInstall = ''
    ln -s $out/bin/fission-cli $out/bin/fission
  '';

  meta = {
    description = "Cli used by end user to interact Fission";
    homepage = "https://fission.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ neverbehave ];
  };
})
