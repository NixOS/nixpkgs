{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gensio";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "gensio";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rgNolodA+fjnOYP1r5pwRYxngrHJ5/Lv1XUsTIlK5KQ=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  configureFlags = [
    "--with-python=no"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ openssl ];

  meta = {
    description = "General Stream I/O";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      emantor
      sarcasticadmin
    ];
    mainProgram = "gensiot";
    platforms = lib.platforms.unix;
  };
})
