{
  lib,
  stdenv,
  fetchFromGitHub,
  fzf,
  git,
  coreutils,
  findutils,
  gnused,
  gnugrep,
  bash,
  makeWrapper,
}:

let
  wrapperPath = lib.makeBinPath [
    fzf
    git
    coreutils
    findutils
    gnused
    gnugrep
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fuzpad";
  version = "2.05.00";

  src = fetchFromGitHub {
    owner = "JianZcar";
    repo = "FuzPad";
    tag = "${finalAttrs.version}";
    hash = "sha256-cqZvJtQbSEMoXVbAOy+aE33IUfwUuzvNIzNuOLf4pwU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bash ];

  installPhase = ''
    install -m 755 -Dt $out/bin $src/bin/fuzpad
  '';

  postFixup = ''
    wrapProgram $out/bin/fuzpad \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "Minimalistic note taking solution powered by fzf";
    homepage = "https://github.com/JianZcar/FuzPad";
    maintainers = with lib.maintainers; [
      nicknb
    ];
    mainProgram = "fuzpad";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})
