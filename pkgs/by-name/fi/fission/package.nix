{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "fission";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5+TyOBHHDhHtAJUtrcWUCRbewGODsut/w3chrmL+dis=";
  };

  vendorHash = "sha256-y5h1lMq99gWhB9T5e8b2t9USgKc2pv+FMgl9wva8t28=";

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
