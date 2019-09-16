{ stdenv, fetchurl, glibcLocales, python3 }:

let
  python = python3.override {
    packageOverrides = self: super: {

      # https://github.com/pimutils/khal/issues/780
      python-dateutil = super.python-dateutil.overridePythonAttrs (oldAttrs: rec {
        version = "2.6.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca";
        };
      });

    };
  };

in with python.pkgs; buildPythonApplication rec {
  version = "0.14.0";
  pname = "khard";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/scheibler/khard/archive/v${version}.tar.gz";
    sha256 = "0m1pc67jz663yfc0xzfpknymn8jj2bpfxaph3pl0mjd3h1zjfyaq";
  };

  # setup.py reads the UTF-8 encoded readme.
  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = [
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

  # Fails; but there are no tests anyway.
  doCheck = false;

  meta = {
    homepage = https://github.com/scheibler/khard;
    description = "Console carddav client";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
