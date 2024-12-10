{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mev-boost";
  version = "1.7.1";
  src = fetchFromGitHub {
    owner = "flashbots";
    repo = "mev-boost";
    rev = "v${version}";
    hash = "sha256-4Vxs1Jo7rkw9l0pXfi+J7YmzQawt7tc19I1MdHQgjBA=";
  };

  vendorHash = "sha256-yfWDGVfgCfsmzI5oxEmhHXKCUAHe6wWTkaMkBN5kQMw=";

  meta = with lib; {
    description = "Ethereum block-building middleware";
    homepage = "https://github.com/flashbots/mev-boost";
    license = licenses.mit;
    mainProgram = "mev-boost";
    maintainers = with maintainers; [ ekimber ];
    platforms = platforms.unix;
  };
}
