{stdenv, fetchurl, openssl}:
stdenv.mkDerivation {
  name = "msmtp-1.4.21";

  src = fetchurl {
    url = mirror://sourceforge/msmtp/msmtp-1.4.21.tar.bz2;
    sha256 = "1yjgy56n02qs25728psg296amhbdkxq2pv1q3l484f3r9pjrpcrg";
  };

  buildInputs = [ openssl ];

  meta = { 
      description = "a MUA";
      homepage = http://msmtp.sourceforge.net/;
      license = "GPL";
    }; 
}
