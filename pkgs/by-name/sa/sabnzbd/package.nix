{
  lib,
  stdenv,
  coreutils,
  fetchFromGitHub,
  fetchPypi,
  python3,
  par2cmdline-turbo,
  unzip,
  unrar,
  p7zip,
  util-linux,
  makeWrapper,
  nixosTests,
}:

let
  sabctoolsVersion = "8.2.6";
  sabctoolsHash = "sha256-olZSIjfP2E1tkCG8WzEZfrBJuDEp3PZyFFE5LJODEZE=";

  pythonEnv = python3.withPackages (
    ps: with ps; [
      apprise
      babelfish
      cffi
      chardet
      cheetah3
      cheroot
      cherrypy
      configobj
      cryptography
      feedparser
      guessit
      jaraco-classes
      jaraco-collections
      jaraco-context
      jaraco-functools
      jaraco-text
      more-itertools
      notify2
      orjson
      portend
      puremagic
      pycparser
      pysocks
      python-dateutil
      pytz
      rarfile
      rebulk
      # sabnzbd requires a specific version of sabctools
      (sabctools.overridePythonAttrs (old: {
        version = sabctoolsVersion;
        src = fetchPypi {
          pname = "sabctools";
          version = sabctoolsVersion;
          hash = sabctoolsHash;
        };
      }))
      sabyenc3
      sgmllib3k
      six
      tempora
      zc-lockfile
    ]
  );
  path = lib.makeBinPath [
    coreutils
    par2cmdline-turbo
    unrar
    unzip
    p7zip
    util-linux
  ];
in
stdenv.mkDerivation rec {
  version = "4.5.5";
  pname = "sabnzbd";

  src = fetchFromGitHub {
    owner = "sabnzbd";
    repo = "sabnzbd";
    rev = version;
    hash = "sha256-XEWMy+Ph47neyQubehegcOxucClB1Z9t1QDLN7FrxaY=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pythonEnv ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R * $out/
    mkdir $out/bin
    echo "${pythonEnv}/bin/python $out/SABnzbd.py \$*" > $out/bin/sabnzbd
    chmod +x $out/bin/sabnzbd
    wrapProgram $out/bin/sabnzbd --set PATH ${path}

    runHook postInstall
  '';

  passthru = {
    tests.smoke-test = nixosTests.sabnzbd;
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Usenet NZB downloader, par2 repairer and auto extracting server";
    homepage = "https://sabnzbd.org";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [
      jojosch
      adamcstephens
    ];
    mainProgram = "sabnzbd";
  };
}
