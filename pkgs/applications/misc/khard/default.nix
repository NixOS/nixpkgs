{ stdenv, glibcLocales, python3 }:

python3.pkgs.buildPythonApplication rec {
  version = "0.15.1";
  pname = "khard";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "18ba2xgfq8sw0bg6xmlfjpizid1hkzgswcfcc54gl21y2dwfda2w";
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
    homepage = https://github.com/scheibler/khard;
    description = "Console carddav client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
