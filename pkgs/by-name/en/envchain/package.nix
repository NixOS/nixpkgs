{
  lib,
  stdenv,
  fetchFromGitHub,
  libedit,
  libsecret,
  ncurses,
  pkg-config,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "envchain";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sorah";
    repo = "envchain";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QUy38kJzMbYOyT86as4/yq2ctcszSnB8a3eVWxgd4Fo=";
  };

  postPatch = ''
    sed -i -e "s|-ltermcap|-lncurses|" Makefile
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libsecret
    readline
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libedit
    ncurses
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = {
    description = "Set environment variables with macOS keychain or D-Bus secret service";
    homepage = "https://github.com/sorah/envchain";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "envchain";
  };
})
