{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  iotools,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "psb_status";
  version = "0-unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "mkopec";
    repo = "psb_status";
    rev = "be896832c53d6b0b70cf8a87f7ee46ad33deefc2";
    hash = "sha256-4anPyjO8y3FgnYWa4bGFxI8Glk9srw/XF552tnixc8I=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 psb_status.sh $out/bin/psb_status
    wrapProgram $out/bin/psb_status \
      --prefix PATH : ${lib.makeBinPath [ iotools ]}

    runHook postInstall
  '';

  meta = {
    description = "Script to check Platform Secure Boot enablement on Zen based AMD CPUs";
    homepage = "https://github.com/mkopec/psb_status";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phodina ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "psb_status";
  };
})
