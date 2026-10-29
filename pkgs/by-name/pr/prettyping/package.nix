{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prettyping";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "denilsonsa";
    repo = "prettyping";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-GhsoWnhX9xBnupmmHuKW9DA2KFgIzVbSO0CyR2FpJ74=";
  };

  installPhase = ''
    install -Dt $out/bin prettyping
  '';

  meta = {
    homepage = "https://github.com/denilsonsa/prettyping";
    description = "Wrapper around the standard ping tool with the objective of making the output prettier, more colorful, more compact, and easier to read";
    mainProgram = "prettyping";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qoelet ];
  };
})
