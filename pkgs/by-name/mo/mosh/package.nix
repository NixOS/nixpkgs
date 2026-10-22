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
  autoconf-archive,
  autoreconfHook,
  openssh,
  bash-completion,
  withUtempter ? stdenv.hostPlatform.isLinux,
  libutempter,
  # build server binary only when set to false (useful for perlless systems)
  withClient ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mosh";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "mobile-shell";
    repo = "mosh";
    rev = "mosh-${finalAttrs.version}";
    hash = "sha256-tlSsHu7JnXO+sorVuWWubNUNdb9X0/pCaiGG5Y0X/g8=";
  };

  nativeBuildInputs = [
    autoconf-archive
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
  ]
  ++ lib.optionals withClient [
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
  ];

  # remove the m4 directory, as it contains only ancient versions of macros
  # from autoconf-archive or pkg-config. instead, we fetch up-to-date versions
  # from the packages which provide them. this allows selecting modern C++
  # standard versions, which is important with e.g. GCC 16.
  postPatch = ''
    rm -rf m4

    substituteInPlace scripts/mosh.pl \
      --subst-var-by ssh "${openssh}/bin/ssh" \
      --subst-var-by mosh-client "$out/bin/mosh-client"
  '';

  configureFlags = [ "--enable-completion" ] ++ lib.optional withUtempter "--with-utempter";

  postInstall =
    if withClient then
      ''
        wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
      ''
    else
      ''
        rm $out/bin/mosh
        rm $out/bin/mosh-client
        rm -r $out/share/{man,bash-completion}
      '';

  meta = {
    homepage = "https://mosh.org/";
    description = "Mobile shell (ssh replacement)";
    longDescription = ''
      Remote terminal application that allows roaming, supports intermittent
      connectivity, and provides intelligent local echo and line editing of
      user keystrokes.

      Mosh is a replacement for SSH. It's more robust and responsive,
      especially over Wi-Fi, cellular, and long-distance links.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ skeuchel ];
    platforms = lib.platforms.unix;
  };
})
