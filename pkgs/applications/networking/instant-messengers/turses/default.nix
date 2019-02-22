{ stdenv, python3Packages }:

with stdenv.lib;
with python3Packages;

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "turses";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15mkhm3b5ka42h8qph0mhh8izfc1200v7651c62k7ldcs50ib9j6";
  };

  buildInputs = [ mock pytest coverage tox ];
  propagatedBuildInputs = [ urwid tweepy future ];

  checkPhase = ''
    TMP_TURSES=`echo turses-$RANDOM`
    mkdir $TMP_TURSES
    PYTHONPATH=tests:$PYTHONPATH HOME=$TMP_TURSES py.test tests/
    rm -rf $TMP_TURSES
  '';

  patchPhase = ''
    sed -i -e 's|urwid==1.3.0|urwid==${getVersion urwid}|' setup.py
    sed -i -e "s|future==0.14.3|future==${getVersion future}|" setup.py
    sed -i -e "s|tweepy==3.3.0|tweepy==${getVersion tweepy}|" setup.py
    sed -i -e "s|config.generate_config_file.assert_called_once()|assert config.generate_config_file.call_count == 1|" tests/test_config.py
    sed -i -e "s|self.observer.update.assert_called_once()|assert self.observer.update.call_count == 1|" tests/test_meta.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/alejandrogomez/turses;
    description = "A Twitter client for the console";
    license = licenses.gpl3;
    maintainers = with maintainers; [ garbas ];
    platforms = platforms.unix;
  };
}
