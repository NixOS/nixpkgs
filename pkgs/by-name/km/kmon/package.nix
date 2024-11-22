{ lib, rustPlatform, fetchFromGitHub, installShellFiles, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1OsQT3RMNLQMjr4aA2u5knp/HhOUOJ/oZYHG/+cTQFQ=";
  };

  cargoHash = "sha256-9xRlm5pWWRRPq6MMwiMADmm8Bg2FqKNSfv7tm1ONiiQ=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libxcb ];

  postInstall = ''
    installManPage $releaseDir/../man/kmon.8
    installShellCompletion $releaseDir/../completions/kmon.{bash,fish} \
      --zsh $releaseDir/../completions/_kmon
  '';

  meta = with lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    changelog = "https://github.com/orhun/kmon/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
    mainProgram = "kmon";
  };
}
