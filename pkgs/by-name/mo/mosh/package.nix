{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  protobuf,
  ncurses,
  pkg-config,
  makeWrapper,
  perl,
  openssl,
  autoreconfHook,
  openssh,
  bash-completion,
  fetchpatch,
  withUtempter ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isMusl,
  libutempter,
}:

stdenv.mkDerivation rec {
  pname = "mosh";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "mobile-shell";
    repo = "mosh";
    rev = "mosh-${version}";
    hash = "sha256-tlSsHu7JnXO+sorVuWWubNUNdb9X0/pCaiGG5Y0X/g8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
    protobuf
    perl
  ];
  buildInputs = [
    protobuf
    ncurses
    zlib
    openssl
    bash-completion
    perl
  ]
  ++ lib.optional withUtempter libutempter;

  strictDeps = true;

  enableParallelBuilding = true;

  patches = [
    ./ssh_path.patch
    ./mosh-client_path.patch
    # Fix build with bash-completion 2.10
    ./bash_completion_datadir.patch

    # Fixes build with protobuf3 23.x
    (fetchpatch {
      url = "https://github.com/mobile-shell/mosh/commit/eee1a8cf413051c2a9104e8158e699028ff56b26.patch";
      hash = "sha256-CouLHWSsyfcgK3k7CvTK3FP/xjdb1pfsSXYYQj3NmCQ=";
    })
  ];

  postPatch = ''
    substituteInPlace scripts/mosh.pl \
      --subst-var-by ssh "${openssh}/bin/ssh" \
      --subst-var-by mosh-client "$out/bin/mosh-client"
  '';

  configureFlags = [ "--enable-completion" ] ++ lib.optional withUtempter "--with-utempter";

  postInstall = ''
    wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
  '';

  meta = with lib; {
    homepage = "https://mosh.org/";
    description = "Mobile shell (ssh replacement)";
    longDescription = ''
      Remote terminal application that allows roaming, supports intermittent
      connectivity, and provides intelligent local echo and line editing of
      user keystrokes.

      Mosh is a replacement for SSH. It's more robust and responsive,
      especially over Wi-Fi, cellular, and long-distance links.
    '';
    license = licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ skeuchel ];
    platforms = platforms.unix;
  };
}
