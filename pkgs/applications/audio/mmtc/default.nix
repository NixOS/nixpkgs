{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GQ1SoZE74o8fsXHVdjdEMbdUeefyPb4FXxidcHCy180=";
  };

  cargoSha256 = "sha256-2IcOwjYTRl2tCB/YAuDACpgaRKZ/21IKWpVs+koYH3k=";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    completions=($releaseDir/build/mmtc-*/out/completions)
    installShellCompletion $completions/mmtc.{bash,fish} --zsh $completions/_mmtc
  '';

  GEN_COMPLETIONS = 1;

  meta = with lib; {
    description = "Minimal mpd terminal client that aims to be simple yet highly configurable";
    homepage = "https://github.com/figsoda/mmtc";
    changelog = "https://github.com/figsoda/mmtc/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
