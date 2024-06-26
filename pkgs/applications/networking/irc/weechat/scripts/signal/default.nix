{ fetchFromGitHub, lib, stdenv, weechat }:

stdenv.mkDerivation {
  pname = "signal";
  version = "unstable-2024-01-06";

  src = fetchFromGitHub {
    owner = "thefinn93";
    repo = "signal-weechat";
    rev = "87ffb9fd5228f0b7c66615057e76502adba1e00f";
    hash = "sha256-cnvLduG7ivl5JjLfgaTgI4+tlYf1IAOZraE1/Ql0M1A=";
  };

  installPhase = ''
    install -D signal.py $out/share/signal.py
  '';
  passthru.scripts = [ "signal.py" ];

  meta = with lib; {
    inherit (weechat.meta) platforms;
    description = "Use Signal in WeeChat";
    homepage = "https://github.com/thefinn93/signal-weechat";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ getpsyched ];
  };
}
