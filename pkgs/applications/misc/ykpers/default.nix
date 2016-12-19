{stdenv, fetchurl, pkgconfig, libusb1, libyubikey}:

stdenv.mkDerivation rec
{
  version = "1.17.2";
  name = "ykpers-${version}";

  src = fetchurl
  {
    url = "http://opensource.yubico.com/yubikey-personalization/releases/${name}.tar.gz";
    sha256 = "1z6ybpdhl74phwzg2lhxhipqf7xnfhg52dykkzb3fbx21m0i4jkh";
  };

  buildInputs = [pkgconfig libusb1 libyubikey];

  meta =
  {
    homepage = "http://opensource.yubico.com/yubikey-personalization/";
    description = "YubiKey Personalization cross-platform library and tool";
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.calrama ];
    platforms = stdenv.lib.platforms.linux;
  };
}
