{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "gobgp";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-52eJtAQfDF76vvLQMxnttPgXppaumZcZ/toOoLeYBu8=";
  };

  vendorHash = "sha256-9r8LZlCF4sr8VTyJfDktjhk32afc8ep7GXtqxUnAleE=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [ "cmd/gobgp" ];

  meta = {
    description = "CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ higebu ];
    mainProgram = "gobgp";
  };
})
