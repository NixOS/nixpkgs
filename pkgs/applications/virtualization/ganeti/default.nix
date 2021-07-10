{ lib, stdenv, fetchFromGitHub, fetchpatch
, autoreconfHook
, bash
# ganeti expects to be able to symlink /bin/true to other names, which doesn't work when it is itself a symlink.
, coreutils-prefixed
, curl
, cabal-install
, fakeroot
, fping
, ghc
, glibcLocales
, graphviz
, hlint
, iproute
, man
, ndisc6
, openssh
, pandoc
, procps
, python3
, qemu
, socat
, tzdata
}:

let
  ghc' = ghc.withPackages (g: with g; [
    attoparsec
    base64-bytestring
    Cabal_3_2_1_0
    cabal-install
    cryptonite
    g.curl
    hinotify
    hsc2hs
    hscolour
    hslogger
    json
    lens
    lifted-base
    network
    old-time
    regex-pcre
    snap-server
    PSQueue
    temporary
    test-framework-hunit
    test-framework-quickcheck2
    utf8-string
    vector
    zlib
  ]);

  python' = python3.withPackages (p: with p; [
    bitarray
    coverage
    mock
    paramiko
    pep8
    psutil
    pycurl
    pyinotify
    pylint
    pyopenssl
    pyparsing
    pyyaml
    simplejson
    sphinx
  ]);

in stdenv.mkDerivation rec {
  pname = "ganeti";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1mw9nmq5i02z005ar63amvf8rg4qmjghnyd8n0wrf57n8q4vqp6x";
  };

  patches = [
    ./disable-test-resetenv.patch
    (fetchpatch {
      url = "https://git.savannah.gnu.org/cgit/guix.git/plain/gnu/packages/patches/ganeti-disable-version-symlinks.patch";
      sha256 = "0gs8s01wz8zl26gpgachr9plrxlfhc0rr6yli0cgqqkqv9cad7d4";
    })
    ./disable-tests.patch
  ];

  postPatch = ''
    find . -type f | xargs sed -i 's,/bin/bash,${bash}/bin/bash,g'
    find . -type f | xargs sed -i 's,/usr/bin/env,${coreutils-prefixed}/bin/env,g'
    find . -type f | xargs sed -i 's,/bin/true,${coreutils-prefixed}/bin/true,g'
    find . -type f | xargs sed -i 's,/bin/ls,${coreutils-prefixed}/bin/ls,g'
    patchShebangs .
    substituteInPlace Makefile.am \
      --replace "\$(DESTDIR)\''${localstatedir}" "\$(DESTDIR)\''${prefix}\''${localstatedir}"
    echo "${version}" > ./vcs-version
  '';

  postConfigure = ''
    substituteInPlace Makefile \
      --replace "\$(DESTDIR)\''$(ifupdir)" "\$(DESTDIR)\''${prefix}\''$(ifupdir)"
  '';

  nativeBuildInputs = [
    autoreconfHook
    fakeroot
    ghc'
    glibcLocales
    graphviz
    hlint
    man
    pandoc
    python'
    tzdata
  ];

  buildInputs = [
    bash
    coreutils-prefixed
    curl
    fping
    iproute
    ndisc6
    openssh
    procps
    python'
    qemu
    socat
  ];

  configureFlags = [
    "--enable-haskell-tests"
    "--localstatedir=/var"
    "--sharedstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-version-links"
  ];

  enableParallelBuilding = true;

  doCheck = true;
  checkPhase = ''
    make py-tests
    make hs-tests
  '';

  meta = with lib; {
    description = "Ganeti is a virtual machine cluster management tool";
    longDescription = ''
      Ganeti is a virtual machine cluster management tool built on top of existing virtualization technologies such as
      Xen or KVM and other open source software.
    '';
    license = licenses.bsd2;
    homepage = "http://www.ganeti.org/";
    maintainers = with maintainers; [ hexa ];
  };
}
