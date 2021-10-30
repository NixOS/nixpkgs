{ lib, stdenv, fetchurl, weechat }:

stdenv.mkDerivation {
  pname = "buffer_autoset";
  version = "1.2";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/weechat/scripts/2b308b44df39ba6563d02b2bcd40c384ec2777dc/python/buffer_autoset.py";
    sha256 = "0csl3sfpijdbq1j6wabx347lvn91a24a2jfx5b5pspfxz7gixli1";
  };

  dontUnpack = true;

  passthru.scripts = [ "buffer_autoset.py" ];

  installPhase = ''
    install -D $src $out/share/buffer_autoset.py
  '';

  meta = with lib; {
    inherit (weechat.meta) platforms;
    description = "buffer_autoset.py is a weechat script which auto-set buffer properties when a buffer is opened.";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ govanify ];
  };
}
