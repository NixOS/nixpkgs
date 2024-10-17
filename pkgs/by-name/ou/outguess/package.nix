{
  fetchFromGitHub,
  stdenv,
  lib,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "outguess";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "outguess";
    rev = finalAttrs.version;
    hash = "sha256-yv01jquPTnVk9fd1tqAt1Lxis+ZHZqdG3NiTFxfoXAE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--with-generic-jconfig" ];

  meta = {
    description = "Universal steganographic tool that allows the insertion of hidden information into the redundant bits of data sources";
    homepage = "https://github.com/resurrecting-open-source-projects/outguess";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    mainProgram = "outguess";
    platforms = lib.platforms.unix;
  };
})
