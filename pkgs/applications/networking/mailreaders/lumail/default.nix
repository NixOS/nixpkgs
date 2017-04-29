{ stdenv, fetchurl, pkgconfig, lua5_2, file, ncurses, gmime, pcre-cpp
, perl, perlPackages }:

let
  version = "2.9";
in
stdenv.mkDerivation {
  name = "lumail-${version}";

  src = fetchurl {
    url = "https://lumail.org/download/lumail-${version}.tar.gz";
    sha256 = "1rni5lbic36v4cd1r0l28542x0hlmfqkl6nac79gln491in2l2sc";
  };

  buildInputs = [
    pkgconfig lua5_2 file ncurses gmime pcre-cpp
    perl perlPackages.JSON perlPackages.NetIMAPClient
  ];

  preConfigure = ''
    sed -e 's|"/etc/lumail2|LUMAIL_LUAPATH"/..|' -i src/lumail2.cc src/imap_proxy.cc

    perlFlags=
    for i in $(IFS=:; echo $PERL5LIB); do
        perlFlags="$perlFlags -I$i"
    done

    sed -e "s|^#\!\(.*/perl.*\)$|#\!\1$perlFlags|" -i perl.d/imap-proxy
  '';

  makeFlags = [
    "LVER=lua"
    "PREFIX=$(out)"
    "SYSCONFDIR=$(out)/etc"
  ];

  postInstall = ''
    cp lumail2.user.lua $out/etc/lumail2/
  '';

  meta = with stdenv.lib; {
    description = "Console-based email client";
    homepage = https://lumail.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [orivej];
  };
}
