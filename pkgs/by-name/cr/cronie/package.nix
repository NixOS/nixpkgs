{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cronie";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "cronie-crond";
    repo = "cronie";
    rev = "cronie-${finalAttrs.version}";
    hash = "sha256-WrzdpE9t7vWpc8QFoFs+S/HgHwsidRNmfcHp7ltSWQw=";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/cronie-crond/cronie";
    description = "Cron replacement, based on vixie-cron";
    changelog = "https://github.com/cronie-crond/cronie/blob/master/ChangeLog";
    license = with lib.licenses; [
      gpl2Plus
      isc
      lgpl21Plus
    ];
    mainProgram = "crond";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
