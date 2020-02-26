{ stdenv, perl, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "mutt-trim";
  version = "2020-02-26";

  src = fetchFromGitHub {
    owner  = "Konfekt";
    repo   = "mutt-trim";
    rev    = "eeaacb886f78b00e704cb06faec7fd7d2dbb7caa";
    sha256 = "0bl6msck0skys0vaaajax1ghbsidi6yvqzz8ns0vry41gmbyd176";
  };

  propagatedBuildInputs = [ perl ];

  buildPhase = null;

  installPhase = ''
    mkdir -p $out/bin/
    cp -v mutt-trim $out/bin/
    chmod +x $out/bin/mutt-trim
  '';

  postFixup = ''
    patchShebangs $out/bin
  '';

  meta = with stdenv.lib; {
    description = "unclutter and normalize quoted text in an e-mail";
    # no license yet
    #license = ;
    homepage = "https://github.com/Konfekt/mutt-trim";
    platforms = platforms.unix;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}

