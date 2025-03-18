{
  lib,
  stdenv,
  fetchFromSourcehut,
  dcp385c-lpr,
}:
stdenv.mkDerivation {
  pname = "dcp385c-brprintconf";
  version = "1.1.2+1";

  src = fetchFromSourcehut {
    owner = "~marcin-serwin";
    repo = "brprintconf";
    rev = "6a1b9bf9de86ca15ca030a6a962ae5d9c2db8ad4";
    hash = "sha256-hgVcFDAnHT3+0Yj276tcwD6xp8YNWN7S0WW8QGCy2hI=";
  };

  postPatch = ''
    reldir='local/Brother/Printer/%s/inf'

    substituteInPlace brprintconf_dcp385c.c \
      --replace-fail "/usr/$reldir/br%sfunc" "${dcp385c-lpr}/$reldir/br%sfunc" \
      --replace-fail "/usr/$reldir/br%src" "/var/cache/cups/br%src"
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://git.sr.ht/~marcin-serwin/brprintconf";
    description = "Decompiled source of brprintconf_dcp385c";
    license = with lib.licenses; [
      cc0
      brotherEula
    ];
    platforms = lib.platforms.linux;
  };
}
