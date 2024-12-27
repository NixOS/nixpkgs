{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "keedump";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ynuwenhof";
    repo = "keedump";
    rev = "refs/tags/v${version}";
    hash = "sha256-V7wQZoUnISELuzjSUz+CJ77XJvlnGBK2n4U4pKlk+xI=";
  };

  cargoHash = "sha256-b5jRWmyCvKCDn1fIXTtLCI1Ckr+Ttt7erDbZs4U2TcE=";

  meta = with lib; {
    description = "PoC KeePass master password dumper";
    homepage = "https://github.com/ynuwenhof/keedump";
    changelog = "https://github.com/ynuwenhof/keedump/releases/tag/v${version}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "keedump";
  };
}
