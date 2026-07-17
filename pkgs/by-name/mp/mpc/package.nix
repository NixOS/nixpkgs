{
  lib,
  fetchFromGitHub,
  installShellFiles,
  libiconv,
  libmpdclient,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpc";
  version = "0.35";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "mpc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oVdnj3nsYvOHcIOgoamLamriuWu9lucWUQtxVmXZabs=";
  };

  buildInputs = [
    libmpdclient
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeBuildInputs = [
    installShellFiles
    meson
    ninja
    pkg-config
    python3Packages.sphinx
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { NIX_LDFLAGS = "-liconv"; };

  postInstall = ''
    installShellCompletion --cmd mpc --bash $out/share/doc/mpc/contrib/mpc-completion.bash
  '';

  postFixup = ''
    rm $out/share/doc/mpc/contrib/mpc-completion.bash
  '';

  meta = {
    homepage = "https://www.musicpd.org/clients/mpc/";
    description = "Minimalist command line interface to MPD";
    changelog = "https://raw.githubusercontent.com/MusicPlayerDaemon/mpc/refs/heads/master/NEWS";
    license = lib.licenses.gpl2Plus;
    mainProgram = "mpc";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
