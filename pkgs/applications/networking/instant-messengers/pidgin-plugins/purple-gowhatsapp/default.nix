{ stdenv, fetchurl, pidgin }:

stdenv.mkDerivation {
  pname = "purple-gowhatsapp";
  version = "2020-12-08";

  src = fetchurl {
    url = "https://buildbot.hehoe.de/purple-gowhatsapp/builds/libgowhatsapp_0.4.1~gitb84fdd7+gowhatsapp~git64cc8cf_amd64_ubuntu18.04.so";
    name = "purple-gowhatsapp.so";
    sha256 = "1g8d4wic96jixkizn8lbszl1nvqrdwjjxqnin9cwfw4wwxmz4ki6";
  };
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/lib/purple-2
    cp $src $out/lib/purple-2/
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/hoehermann/purple-gowhatsapp";
    description = "A libpurple/Pidgin plugin for WhatsApp Web.";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vldn-dev ];
  };
}
