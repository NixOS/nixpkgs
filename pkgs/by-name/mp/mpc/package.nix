{
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.34";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "mpc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2FjYBfak0IjibuU+CNQ0y9Ei8hTZhynS/BK2DNerhVw=";
  };

  patches = [
    # fix the build with meson 0.60 (https://github.com/MusicPlayerDaemon/mpc/pull/76)
    (fetchpatch {
      url = "https://github.com/MusicPlayerDaemon/mpc/commit/b656ca4b6c2a0d5b6cebd7f7daa679352f664e0e.patch";
      sha256 = "sha256-fjjSlCKxgkz7Em08CaK7+JAzl8YTzLcpGGMz2HJlsVw=";
    })
  ];

  buildInputs = [
    libmpdclient
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  nativeBuildInputs = [
    installShellFiles
    meson
    ninja
    pkg-config
    python3Packages.sphinx
  ];

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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
