{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "weechat-autosort";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "de-vri-es";
    repo = pname;
    rev = version;
    sha256 = "0a2gc8nhklvlivradhqy2pkymsqyy01pvzrmwg60cln8snmcqpd5";
  };

  passthru.scripts = [ "autosort.py" ];
  installPhase = ''
    install -D autosort.py $out/share/autosort.py
  '';

  meta = with stdenv.lib; {
    description = "Autosort is a weechat script to automatically or manually keep your buffers sorted";
    homepage = https://github.com/de-vri-es/weechat-autosort;
    license = licenses.gpl3;
    maintainers = with maintainers; [ emily ];
  };
}
