{ lib
, fetchpatch
, fetchFromGitHub
, fetchPypi
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # Support for later tweepy releases is missing
      # https://github.com/louipc/turses/issues/12
      tweepy = super.tweepy.overridePythonAttrs (oldAttrs: rec {
        version = "3.10.0";

        src = fetchFromGitHub {
          owner = "tweepy";
          repo = "tweepy";
          rev = "v${version}";
          sha256 = "0k4bdlwjna6f1k19jki4xqgckrinkkw8b9wihzymr1l04rwd05nw";
        };
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
          super.six
          super.requests.optional-dependencies.socks
        ];
        doCheck = false;
      });
    };
  };
in
with py.pkgs;

buildPythonPackage rec {
  pname = "turses";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15mkhm3b5ka42h8qph0mhh8izfc1200v7651c62k7ldcs50ib9j6";
  };

  propagatedBuildInputs = with py.pkgs; [
    urwid
    tweepy
    future
  ];

  nativeCheckInputs = with py.pkgs; [
    mock
    pytest
    coverage
    tox
  ];

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

  postPatch = ''
    substituteInPlace setup.py \
      --replace "urwid==1.3.0" "urwid" \
      --replace "future==0.14.3" "future" \
      --replace "tweepy==3.3.0" "tweepy"
    substituteInPlace tests/test_config.py \
      --replace "config.generate_config_file.assert_called_once()" "assert config.generate_config_file.call_count == 1"
    substituteInPlace tests/test_meta.py \
      --replace "self.observer.update.assert_called_once()" "assert self.observer.update.call_count == 1"
  '';

  checkPhase = ''
    TMP_TURSES=`echo turses-$RANDOM`
    mkdir $TMP_TURSES
    PYTHONPATH=tests:$PYTHONPATH HOME=$TMP_TURSES py.test tests/
    rm -rf $TMP_TURSES
  '';

  meta = with lib; {
    description = "A Twitter client for the console";
    mainProgram = "turses";
    homepage = "https://github.com/louipc/turses";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
