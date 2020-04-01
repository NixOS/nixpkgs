{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "with-2016-08-20";
  src = fetchFromGitHub {
    owner = "mchav";
    repo = "With";
    rev = "cc2828bddd92297147d4365765f4ef36385f050a";
    sha256 = "10m2xv6icrdp6lfprw3a9hsrzb3bip19ipkbmscap0niddqgcl9b";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp with $out/bin/with
  '';
  meta = {
    homepage = "https://github.com/mchav/With";
    description = "Command prefixing for continuous workflow using a single tool";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
