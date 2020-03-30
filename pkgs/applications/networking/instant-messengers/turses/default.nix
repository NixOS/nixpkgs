{ stdenv, fetchpatch, python3Packages }:

with stdenv.lib;
with python3Packages;

buildPythonPackage rec {
  pname = "turses";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15mkhm3b5ka42h8qph0mhh8izfc1200v7651c62k7ldcs50ib9j6";
  };

  checkInputs = [ mock pytest coverage tox ];
  propagatedBuildInputs = [ urwid tweepy future ];

  LC_ALL = "en_US.UTF-8";

  patches = [
    (fetchpatch {
      url = "https://github.com/louipc/turses/commit/be0961b51f502d49fd9e2e5253ac130e543a31c7.patch";
      sha256 = "17s1n0275mcj03vkf3n39dmc09niwv4y7ssrfk7k3vqx22kppzg3";
    })
    # python 3.7+ support
    (fetchpatch {
      url = "https://github.com/booxter/turses/commit/e6e285eae50fc3d2042a476185fe60daef1e758e.patch";
      sha256 = "0g2zsrny955viwgs2l6gpiiz8m67b5sgdcxkjmfimfvvih5sg79f";
    })
  ];

  checkPhase = ''
    TMP_TURSES=`echo turses-$RANDOM`
    mkdir $TMP_TURSES
    PYTHONPATH=tests:$PYTHONPATH HOME=$TMP_TURSES py.test tests/
    rm -rf $TMP_TURSES
  '';

  postPatch = ''
    sed -i -e 's|urwid==1.3.0|urwid==${getVersion urwid}|' setup.py
    sed -i -e "s|future==0.14.3|future==${getVersion future}|" setup.py
    sed -i -e "s|tweepy==3.3.0|tweepy==${getVersion tweepy}|" setup.py
    sed -i -e "s|config.generate_config_file.assert_called_once()|assert config.generate_config_file.call_count == 1|" tests/test_config.py
    sed -i -e "s|self.observer.update.assert_called_once()|assert self.observer.update.call_count == 1|" tests/test_meta.py
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/louipc/turses;
    description = "A Twitter client for the console";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
