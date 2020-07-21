{ stdenv, glibcLocales, python3 }:

python3.pkgs.buildPythonApplication rec {
  version = "0.16.1";
  pname = "khard";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0fg4qh5gzki5wg958wlpc8a2icnk74gzg33lqxjm755cfnjng7qd";
  };

  propagatedBuildInputs = with python3.pkgs; [
    atomicwrites
    configobj
    vobject
    ruamel_yaml
    ruamel_base
    unidecode
  ];

  postInstall = ''
    install -D misc/zsh/_khard $out/share/zsh/site-functions/_khard
  '';

  preCheck = ''
    # see https://github.com/scheibler/khard/issues/263
    export COLUMNS=80
  '';

  meta = {
    homepage = "https://github.com/scheibler/khard";
    description = "Console carddav client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
