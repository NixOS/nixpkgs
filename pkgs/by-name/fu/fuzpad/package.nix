{
  lib,
  stdenvNoCC,
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
stdenvNoCC.mkDerivation (finalAttrs: {
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

  patches = [
    ./remove-hardcoded-shell-variable.patch
  ];

  installPhase = ''
    install -m755 -Dt $out/bin bin/fuzpad
  '';

  postFixup = ''
    wrapProgram $out/bin/fuzpad --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "Minimalistic note taking solution powered by fzf";
    homepage = "https://github.com/JianZcar/FuzPad";
    changelog = "https://github.com/JianZcar/FuzPad/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      nicknb
    ];
    mainProgram = "fuzpad";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})
