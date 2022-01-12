{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g2JHY95vkG/Ep2eqz8guteF8fHUso/JuuVijNGkgykA=";
  };

  cargoSha256 = "sha256-tVjy/O5hfnQFC6to8VMGc39mEXhA5lwUIne6pVvDec0=";

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
