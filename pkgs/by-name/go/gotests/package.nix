{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gotests";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "cweill";
    repo = "gotests";
    rev = "v${version}";
    sha256 = "sha256-l2hpve/89e01YJLATkbfqLQAbajlY+96UW4k1MNf/NQ=";
  };

  vendorHash = "sha256-/dP8uA1yWBrtmFNHUvcicPhA2qr5R2v1uSwYi+ciypg=";

  # tests are broken in nix environment
  doCheck = false;

  meta = with lib; {
    description = "Generate Go tests from your source code";
    mainProgram = "gotests";
    homepage = "https://github.com/cweill/gotests";
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.asl20;
  };
}
