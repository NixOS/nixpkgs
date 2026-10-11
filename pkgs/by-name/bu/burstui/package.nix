{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  pkgs,
}:

buildGoModule (finalAttrs: {
  pname = "burstui";
  version = "3.1.0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "trifoliolate-antihypertensivedrug145";
    repo = "burstui";
    rev = "fa9a6e0c3d50736c56cb8ac785ae0320cfcacdd8";
    hash = "sha256-mSWEngpnV1zycqxsW7DW1gVPBQM8EUf/dip/sqV63ps=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-35IockAC27Va3+y2QwbyHeyKezgAG2F7mqTdNpo51lA=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.commitDate=1970-01-01T00:00:00Z"
  ];

  postFixup = ''
    wrapProgram $out/bin/burstui \
      --prefix PATH : ${lib.makeBinPath [ pkgs.gobuster ]} \
  '';

  meta = {
    description = "TUI for Gobuster";
    homepage = "https://github.com/trifoliolate-antihypertensivedrug145/burstui";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "burstui";
  };
})
