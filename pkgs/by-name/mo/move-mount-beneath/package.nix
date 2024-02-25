{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "move-mount-beneath";
  version = "unstable-2023-11-26";

  src = fetchFromGitHub {
    owner = "brauner";
    repo = "move-mount-beneath";
    rev = "d3d16c0d7766eb1892fcc24a75f8d35df4b0fe45";
    hash = "sha256-hUboFthw9ABwK6MRSNg7+iu9YbiJALNdsw9Ub3v43n4=";
  };

  installPhase = ''
    runHook preInstall
    install -D move-mount $out/bin/move-mount
    runHook postInstall
  '';

  meta = {
    description = "Toy binary to illustrate adding a mount beneath an existing mount";
    homepage = "https://github.com/brauner/move-mount-beneath";
    license = lib.licenses.mit0;
    maintainers = with lib.maintainers; [ nikstur ];
  };
}
