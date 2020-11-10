{ stdenv, glibcLocales, python3 }:

python3.pkgs.buildPythonApplication rec {
  version = "0.17.0";
  pname = "khard";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "062nv4xkfsjc11k9m52dh6xjn9z68a4a6x1s8z05wwv4jbp1lkhn";
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
