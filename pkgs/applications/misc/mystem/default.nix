{stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mystem";
  version = "3.1";

  src = fetchurl {
    url = "http://download.cdn.yandex.net/mystem/${pname}-${version}-linux-64bit.tar.gz";
    sha256 = "0q3vxvyj5bqllqnlivy5llss39z7j0bgpn6kv8mrc54vjdhppx10";
  };

  buildCommand = ''
    tar -xaf "$src"
    mkdir -p $out/bin
    install -Dm755 mystem $out/bin/mystem
    patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) $out/bin/mystem
  '';

  meta = with stdenv.lib; {
    description = "Morphological analysis of Russian text";
    homepage = https://yandex.ru/dev/mystem/;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ abbradar ];
    platforms = [ "x86_64-linux" ];
  };
}
