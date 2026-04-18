{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "canfigger";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "andy5995";
    repo = "canfigger";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JphvLdBQPOu3a9DNlXTOkQyL0eFLM3FCvGZLPSvbKtA=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "Lightweight library designed to parse configuration files";
    homepage = "https://github.com/andy5995/canfigger";
    changelog = "https://github.com/andy5995/canfigger/blob/${finalAttrs.src.rev}/ChangeLog.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "canfigger";
    platforms = lib.platforms.all;
  };
})
