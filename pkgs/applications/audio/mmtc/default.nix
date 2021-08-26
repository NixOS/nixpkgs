{ fetchFromGitHub, installShellFiles, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ag87hgdg6fvk80fgznba0xjlcajks5w5s6y8lvwhz9irn2kq2rz";
  };

  cargoSha256 = "0lkx0zj9xc0rlrq91l4wydzp430hxlrqyq7ii8wq2fcan8ln22lv";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    completions=($releaseDir/build/mmtc-*/out/completions)
    installShellCompletion ''${completions[0]}/mmtc.{bash,fish}
    installShellCompletion --zsh ''${completions[0]}/_mmtc
  '';

  GEN_COMPLETIONS = "1";

  meta = with lib; {
    description = "Minimal mpd terminal client that aims to be simple yet highly configurable";
    homepage = "https://github.com/figsoda/mmtc";
    changelog = "https://github.com/figsoda/mmtc/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
