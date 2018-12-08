{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "weechat-autosort-${version}";
  version = "unstable-2018-01-11";

  src = fetchFromGitHub {
    owner = "de-vri-es";
    repo = "weechat-autosort";
    rev = "35ccd6335afd78ae8a6e050ed971d54c8524e37e";
    sha256 = "1rgws960xys65cd1m529csalcgny87h7fkiwjv1yj9rpqp088z26";
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
