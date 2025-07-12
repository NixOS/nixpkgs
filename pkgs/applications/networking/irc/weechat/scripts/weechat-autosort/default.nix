{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "weechat-autosort";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "de-vri-es";
    repo = pname;
    rev = "d62fa8633015ebc2676060fcdae88c402977be46";
    sha256 = "sha256-doYDRIWiuHam2i3r3J3BZuWEhopoN4jms/xPXGyypok=";
  };

  passthru.scripts = [ "autosort.py" ];
  installPhase = ''
    install -D autosort.py $out/share/autosort.py
  '';

  meta = with lib; {
    description = "Autosort is a weechat script to automatically or manually keep your buffers sorted";
    homepage = "https://github.com/de-vri-es/weechat-autosort";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ flokli ];
  };
}
