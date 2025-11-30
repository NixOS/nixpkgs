{
  lib,
  stdenv,
  fetchurl,
  weechat,
}:

stdenv.mkDerivation {
  pname = "weechat-go";
  version = "2.7";

  src = fetchurl {
    url = "https://github.com/weechat/scripts/raw/414cff3ee605ba204b607742430a21443c035b08/python/go.py";
    sha256 = "0bnbfpj1qg4yzwbikh1aw5ajc8l44lkb0y0m6mz8grpf5bxk5cwm";
  };

  dontUnpack = true;

  passthru.scripts = [ "go.py" ];

  installPhase = ''
    install -D $src $out/share/go.py
  '';

  meta = with lib; {
    inherit (weechat.meta) platforms;
    description = "WeeChat script to quickly jump to different buffers";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ govanify ];
  };
}
