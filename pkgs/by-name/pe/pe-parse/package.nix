{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  icu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pe-parse";
  version = "2.1.1-unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pe-parse";
    rev = "b0dabd3fdcccd8f53bab500a45e92f37c6fec936";
    hash = "sha256-j1QJ12hEy1c7SRIJSiFwQwJhhDKGbUrquFXDZbNNEDk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ icu ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dump-pe ../tests/assets/example.exe
  '';

  meta = {
    description = "Principled, lightweight parser for Windows portable executable files";
    homepage = "https://github.com/trailofbits/pe-parse";
    changelog = "https://github.com/trailofbits/pe-parse/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arturcygan ];
    mainProgram = "dump-pe";
    platforms = lib.platforms.unix;
  };
})
