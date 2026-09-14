{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastent";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "iczelia";
    repo = "fastent";
    rev = finalAttrs.version;
    hash = "sha256-OxK/5CiQO8mAgRQbP51naHFvo2ZqVrNt55mCnz0klpY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    # for LTO
    export AR="${stdenv.cc.targetPrefix}gcc-ar"
    export NM="${stdenv.cc.targetPrefix}gcc-nm"
    export RANLIB="${stdenv.cc.targetPrefix}gcc-ranlib"
  '';

  configureFlags = [
    "--enable-lto"
  ];

  meta = {
    description = "A faster utility for entropy estimation";
    homepage = "https://github.com/iczelia/fastent";
    changelog = "https://github.com/iczelia/fastent/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mrbenjadmin ];
    platforms = lib.platforms.all;
    mainProgram = "fastent";
  };
})
