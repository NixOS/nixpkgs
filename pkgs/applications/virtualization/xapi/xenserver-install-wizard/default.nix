{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xenserver-install-wizard-0.2.39";
  version = "0.2.39";

  src = fetchurl {
    url = "https://github.com/xenserver/xenserver-install-wizard/archive/0.2.39/xenserver-install-wizard-0.2.39.tar.gz";
    sha256 = "1z2ccj80sq2i6f9gacr34pr05pax2sz1wqhvm0dph1qa2cxyciwr";
  };

  configurePhase = "true";

  buildPhase = "true";

  installPhase = ''
    make DESTDIR=$out
    mkdir -p $out/bin
    ln -s $out/usr/share/xenserver-install-wizard/xenserver-install-wizard.py $out/bin/xenserver-install-wizard
    '';

  meta = {
    homepage = https://github.com/xenserver/xenserver-install-wizard;
    description = "A simple wizard to configure a XenServer";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
