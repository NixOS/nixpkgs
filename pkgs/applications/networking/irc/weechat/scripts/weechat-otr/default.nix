{
  lib,
  stdenv,
  replaceVars,
  buildEnv,
  fetchgit,
  fetchFromGitHub,
  python3Packages,
  gmp,
}:

let
  # pure-python-otr (potr) requires an older version of pycrypto, which is
  # not compatible with pycryptodome. Therefore, the latest patched version
  # of pycrypto will be fetched from the Debian project.
  # https://security-tracker.debian.org/tracker/source-package/python-crypto

  pycrypto = python3Packages.buildPythonPackage rec {
    pname = "pycrypto";
    version = "2.6.1-13.1";
    format = "setuptools";

    src = fetchgit {
      url = "https://salsa.debian.org/sramacher/python-crypto.git";
      rev = "debian/${version}";
      sha256 = "1mahqmlgilgk0rn5hfkhza7kscfm7agdakkb6rqnif9g0qp3s52f";
    };

    postPatch = ''
      for p in debian/patches/*.patch; do
        patch -p1 < "$p"
      done
    '';

    buildInputs = [ gmp ];

    # Tests are relying on old Python 2 modules.
    doCheck = false;

    preConfigure = ''
      sed -i 's,/usr/include,/no-such-dir,' configure
      sed -i "s!,'/usr/include/'!!" setup.py
    '';
  };

  potr = python3Packages.potr.overridePythonAttrs (oldAttrs: {
    propagatedBuildInputs = [ pycrypto ];
  });
in
stdenv.mkDerivation rec {
  pname = "weechat-otr";
  version = "1.9.2";

  src = fetchFromGitHub {
    repo = pname;
    owner = "mmb";
    rev = "v${version}";
    sha256 = "1lngv98y6883vk8z2628cl4d5y8jxy39w8245gjdvshl8g18k5s2";
  };

  patches = [
    (replaceVars ./libpath.patch {
      env = "${
        buildEnv {
          name = "weechat-otr-env";
          paths = [
            potr
            pycrypto
          ];
        }
      }/${python3Packages.python.sitePackages}";
    })
  ];

  passthru.scripts = [ "weechat_otr.py" ];

  installPhase = ''
    mkdir -p $out/share
    cp weechat_otr.py $out/share/weechat_otr.py
  '';

  meta = with lib; {
    homepage = "https://github.com/mmb/weechat-otr";
    license = licenses.gpl3;
    maintainers = with maintainers; [ oxzi ];
    description = "WeeChat script for Off-the-Record messaging";
    knownVulnerabilities = [
      "There is no upstream release since 2018-03."
      "Utilizes deprecated and vulnerable pycrypto library with Debian patches from 2020-04."
    ];
  };
}
