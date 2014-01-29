{stdenv, fetchurl, pkgconfig, libusb1, libyubikey}:

stdenv.mkDerivation rec
{
  version = "1.15.0";
  name = "ykpers-${version}";

  src = fetchurl
  {
    url = "http://opensource.yubico.com/yubikey-personalization/releases/${name}.tar.gz";
    sha256 = "1n4s8kk31q5zh2rm7sj9qmv86yl8ibimdnpvk9ny391a88qlypyd";
  };

  buildInputs = [pkgconfig libusb1 libyubikey];

  meta =
  {
    homepage = "http://opensource.yubico.com/yubikey-personalization/";
    description = "YubiKey Personalization cross-platform library and tool";
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.calrama ];
  };
}
