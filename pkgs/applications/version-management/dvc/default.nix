{ lib
, python3Packages
, fetchFromGitHub
}:

with python3Packages;

let

  aiohttp-retry = buildPythonPackage rec {
    pname = "aiohttp_retry";
    version = "2.4.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "KIwaDZO0s62SkQxWoDJsawVcfhNFAnsm8XOsGFlKl9o=";
    };

    propagatedBuildInputs = [ aiohttp ];
  };

  commonmark = buildPythonPackage rec {
    pname = "commonmark";
    version = "0.9.1";

    propagatedBuildInputs = [
    ];
    doCheck = false;

    src = fetchPypi {
      inherit pname version;
      sha256 = "RS+dyFm+fwZjHdyzKLaRnGeYSsplTl/vs5FNVGka7WA=";
    };
  };

  dictdiffer = buildPythonPackage rec {
    pname = "dictdiffer";
    version = "0.9.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "F7rPX7/mE8zxttUSvXZuayH7eYgioTOqhgmLismZdXg=";
    };

    propagatedBuildInputs = [ setuptools-scm pytest-runner ];
    checkInputs = [ pytest ];
    doCheck = false;
  };

  flatten-dict = buildPythonPackage rec {
    pname = "flatten-dict";
    version = "0.4.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "UGqWtub4Bbga5GoPnzEpC+tfp53tnYDb4bf6I2q0MHY=";
    };

    propagatedBuildInputs = [ six ];
  };

  mailchecker = buildPythonPackage rec {
    pname = "mailchecker";
    version = "4.1.6";

    src = fetchPypi {
      inherit pname version;
      sha256 = "v1blkN3lnrdJjYIm5G+8WjnhNhVIe9l9LLKd3SNA4Gk=";
    };
  };

  python-benedict = buildPythonPackage rec {
    pname = "python-benedict";
    version = "0.24.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "+de0HL5/55s98MEiherPKXoVf6e12dpGETKQirE8OQ8=";
    };

    propagatedBuildInputs = [
      ftfy
      mailchecker
      phonenumbers
      python-dateutil
      python-fsutil
      python-slugify
      pyyaml
      requests
      six
      toml
      xmltodict
    ];

    checkInputs = [ pytest ];
    doCheck = false;
  };

  python-fsutil = buildPythonPackage rec {
    pname = "python-fsutil";
    version = "0.5.0";

    propagatedBuildInputs = [ requests ];

    checkInputs = [ pytest codecov coverage tox ];
    doCheck = false;

    src = fetchPypi {
      inherit pname version;
      sha256 = "AqNHVA0QwWFjkKU2ztc/1n340BxJn0l9CrPeP7sjbw4=";
    };
  };

  rich = buildPythonPackage rec {
    pname = "rich";
    version = "10.16.1";

    propagatedBuildInputs = [
      pygments
      commonmark
      colorama
    ];
    doCheck = false;

    src = fetchPypi {
      inherit pname version;
      sha256 = "SUnnPeMheE72Zk67yFSsgrIP9gsoZQl7k/O5tB4w2ic=";
    };
  };

  scmrepo = buildPythonPackage
    rec {
      pname = "scmrepo";
      version = "0.0.4";

      format = "pyproject";

      src = fetchPypi {
        inherit pname version;
        sha256 = "4ApG8cX1YMNbr9eS/RSwcUThotHDhOIKtEol9fHXwzU=";
      };

      propagatedBuildInputs = [
        GitPython
        dulwich
        pygit2
        pygtrie
        fsspec
        pathspec
        asyncssh
        funcy
      ];
    };

  shtab = buildPythonPackage rec {
    pname = "shtab";
    version = "1.5.2";

    src = fetchPypi {
      inherit pname version;
      sha256 = "N4ucFl1QqLv0N5tZhxA2UHuEexS14BT31gthU6xR6tA=";
    };

    nativeBuildInputs = [ setuptools setuptools_scm ];
    doCheck = false;
  };

in

buildPythonApplication rec {
  pname = "dvc";
  version = "2.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "VDJXkHqEOVLES9seqE8q4z2Gk1hMEXXrSeuV2gwqLkk=";
  };

  nativeBuildInputs = [
    setuptools-scm
    setuptools-scm-git-archive
  ];

  propagatedBuildInputs = [
    ply
    colorama
    configobj
    nanotime
    pyasn1
    voluptuous
    requests
    grandalf
    distro
    appdirs
    ruamel-yaml
    toml
    funcy
    pathspec
    shortuuid
    tqdm
    packaging
    zc_lockfile
    flufl_lock
    networkx
    psutil
    pydot
    flatten-dict
    tabulate
    pygtrie
    dpath
    shtab
    rich
    dictdiffer
    python-benedict
    pyparsing
    typing-extensions
    fsspec
    aiohttp-retry
    diskcache
    scmrepo
  ];

  doCheck = false;

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    license = licenses.asl20;
    homepage = "https://dvc.org";
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
