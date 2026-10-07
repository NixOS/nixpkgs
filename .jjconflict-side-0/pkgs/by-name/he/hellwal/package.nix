{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hellwal";
  version = "1.0.9";
  src = fetchFromGitHub {
    owner = "danihek";
    repo = "hellwal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TD2PxBubYLMkdvPxXJb6xiDo33wnYmUDt7hbGePvFcM=";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    install -Dm755 hellwal -t $out/bin
    mkdir -p $out/share/docs/hellwal
    cp -r templates themes $out/share/docs/hellwal
  '';
  passthru = {
    updateScript = nix-update-script { };
  };
  meta = {
    homepage = "https://github.com/danihek/hellwal";
    description = "Fast, extensible color palette generator";
    longDescription = ''
      Pywal-like color palette generator, but faster and in C.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      danihek
      evanwporter
    ];
    mainProgram = "hellwal";
  };
})
