{ stdenv, glibcLocales, python3 }:

python3.pkgs.buildPythonApplication rec {
  version = "0.16.0";
  pname = "khard";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0a1zpkq0pplmn9flxczq2wafs6zc07r9xx9qi6dqmyv9mhy9d87f";
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

  meta = {
    homepage = "https://github.com/scheibler/khard";
    description = "Console carddav client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
