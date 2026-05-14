{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "move-mount-beneath";
  version = "0-unstable-2025-09-24";

  src = fetchFromGitHub {
    owner = "brauner";
    repo = "move-mount-beneath";
    rev = "f8773d1f99f9cfa2f5bf173e1b1d1b21eb1ee446";
    hash = "sha256-C7QiClwFTKBcdmGilwZSCAsaVoEDXTO9384Y/47JrPk=";
  };

  installPhase = ''
    runHook preInstall
    install -D move-mount $out/bin/move-mount
    runHook postInstall
  '';

  meta = {
    description = "Toy binary to illustrate adding a mount beneath an existing mount";
    mainProgram = "move-mount";
    homepage = "https://github.com/brauner/move-mount-beneath";
    license = lib.licenses.mit0;
    maintainers = with lib.maintainers; [ nikstur ];
  };
}
