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
  version = "2.8.15";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = "gensio";
    rev = "v${version}";
    sha256 = "sha256-EDa95r8x5yIXibJigJXR3PCYTTvJlqB6XBN1RZHq6KM=";
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
}
