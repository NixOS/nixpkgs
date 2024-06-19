{ stdenv, lib, fetchurl, weechat }:

stdenv.mkDerivation {
  pname = "weechat-colorize_nicks";
  version = "27";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/bc8a9051800779a036ba11689a277cd5f03657b2/python/colorize_nicks.py";
    sha256 = "0hiay88vvy171jiq6ahflm0ipb7sslfxwhmmm8psv6qk19rv2sxs";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/colorize_nicks.py
  '';

  passthru = {
    scripts = [ "colorize_nicks.py" ];
  };

  meta = with lib; {
    inherit (weechat.meta) platforms;
    description = "Use the weechat nick colors in the chat area";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ qyliss ];
  };
}
