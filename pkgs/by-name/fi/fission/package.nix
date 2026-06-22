{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "fission";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/EGhEqXmEB8nEVsfXmnCMc8oTl6AondhXupfNY43gvU=";
  };

  vendorHash = "sha256-B+cFjpFhZ5dkPXaNlmokP83wxSuA2CwkujnY8OL8qoI=";

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
