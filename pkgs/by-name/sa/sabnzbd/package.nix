{
  lib,
  coreutils,
  fetchFromGitHub,
  fetchPypi,
  python3Packages,
  par2cmdline-turbo,
  unzip,
  unrar,
  p7zip,
  util-linux,
  makeWrapper,
  nixosTests,
}:

let
  sabctoolsVersion = "9.6.3";
  sabctoolsHash = "sha256-+qzSDV7JER45yBMmyh5Jor4rJLlcE8KPguPnrBmMkSk=";

  path = lib.makeBinPath [
    coreutils
    par2cmdline-turbo
    unrar
    unzip
    p7zip
    util-linux
  ];
in
python3Packages.buildPythonApplication rec {
  version = "5.1.3";
  pname = "sabnzbd";
  # Upstream's pyproject.toml only configures development tools.
  pyproject = false;

  src = fetchFromGitHub {
    owner = "sabnzbd";
    repo = "sabnzbd";
    rev = version;
    hash = "sha256-Ya7AagLwupKmkeOWPbsQB/lWyl/7egTGbcxXqM5yY54=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python3Packages; [
    apprise
    babelfish
    cffi
    chardet
    cheroot
    cherrypy
    configobj
    cryptography
    ct3
    feedparser
    guessit
    hachoir
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
      # sabctools switched to scikit-build-core in 9.7.0
      build-system = [ setuptools ];
    }))
    sabyenc3
    sgmllib3k
    six
    tempora
    zc-lockfile
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R * $out/
    mkdir $out/bin
    makeWrapper ${python3Packages.python.interpreter} $out/bin/sabnzbd \
      --add-flags "$out/SABnzbd.py" \
      --set PATH ${path}

    runHook postInstall
  '';

  # Keep the entry point next to its data files without wrapping importable modules.
  postFixup = ''
    buildPythonPath "$out"
    patchPythonScript "$out/SABnzbd.py"
  '';

  passthru = {
    tests.smoke-test = nixosTests.sabnzbd;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Usenet NZB downloader, par2 repairer and auto extracting server";
    homepage = "https://sabnzbd.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jojosch
    ];
    mainProgram = "sabnzbd";
  };
}
