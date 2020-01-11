{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "weechat-autosort";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "de-vri-es";
    repo = pname;
    rev = version;
    sha256 = "1sbr6ga9krrfgqznvsxjd3hdxzkvslh41ls5xrj7l2p4ws4gwlkn";
  };

  passthru.scripts = [ "autosort.py" ];
  installPhase = ''
    install -D autosort.py $out/share/autosort.py
  '';

  meta = with stdenv.lib; {
    description = "Autosort is a weechat script to automatically or manually keep your buffers sorted";
    homepage = https://github.com/de-vri-es/weechat-autosort;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma27 ];
  };
}
