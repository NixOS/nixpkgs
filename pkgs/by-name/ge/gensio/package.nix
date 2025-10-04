{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "gensio";
    rev = "v${version}";
    sha256 = "sha256-YP5KKHpKVZhJxhCBbdXg6pTgvPRHUwdqlzDlR+hIB+w=";
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

  meta = with lib; {
    description = "General Stream I/O";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      emantor
      sarcasticadmin
    ];
    mainProgram = "gensiot";
    platforms = platforms.unix;
  };
}
