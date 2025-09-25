{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "base24-schemes";
  version = "unstable-2025-9-25";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "317a5e10c35825a6c905d912e480dfe8e71c7559";
    hash = "sha256-d4km8W7w2zCUEmPAPUoLk1NlYrGODuVa3P7St+UrqkM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/
    install base24/*.yaml $out/share/themes/

    runHook postInstall
  '';

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fe2-Nyxar ];
  };
})
