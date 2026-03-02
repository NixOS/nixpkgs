{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pe-parse";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "pe-parse";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XegSZWRoQg6NEWuTSFI1RMvN3GbpLDrZrloPU2XdK2M=";
  };

  nativeBuildInputs = [ cmake ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=deprecated-declarations"
    ]
  );

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
