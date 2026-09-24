{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mtm";
  version = "1.2.1";

  outputs = [
    "out"
    "terminfo"
  ];

  src = fetchFromGitHub {
    owner = "deadpixi";
    repo = "mtm";
    rev = finalAttrs.version;
    sha256 = "0gibrvah059z37jvn1qs4b6kvd4ivk2mfihmcpgx1vz6yg70zghv";
  };

  buildInputs = [ ncurses ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "MANDIR=${placeholder "out"}/share/man/man1"
  ];

  preInstall = ''
    mkdir -p $out/bin/ $out/share/man/man1
  '';

  postInstall = ''
    mkdir -p $terminfo/share/terminfo $out/nix-support
    tic -x -o $terminfo/share/terminfo mtm.ti
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Perhaps the smallest useful terminal multiplexer in the world";
    homepage = "https://github.com/deadpixi/mtm";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "mtm";
  };
})
