{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Fix build with GCC 15
    (fetchpatch {
      url = "https://github.com/cronie-crond/cronie/commit/09c630c654b2aeff06a90a412cce0a60ab4955a4.patch";
      hash = "sha256-OU6pCFeEPC32cPE3K9Uq9HuvpwdUZpaBtyxNOaJkFVM=";
    })
  ];

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
