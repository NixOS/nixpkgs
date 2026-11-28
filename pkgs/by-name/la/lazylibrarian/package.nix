{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  python3,
  makeWrapper,
  nix-update-script,
  calibre,
  ffmpeg-headless,
  calibreSupport ? true,
  ffmpegSupport ? true,
}:

let
  dependencies =
    ps: with ps; [
      apprise
      apscheduler
      beautifulsoup4
      cherrypy
      cherrypy-cors
      curl-cffi
      deluge-client
      googletrans
      html5lib
      httpagentparser
      httplib2
      irc
      iso639-lang
      langid
      lxml
      mako
      pillow
      pyopenssl
      pyparsing
      pypdf
      python-magic
      rapidfuzz
      requests
      slskd-api
      tzdata
      urllib3
      webencodings
      xmltodict
    ];

  pythonEnv = python3.withPackages dependencies;

  runtimePath =
    lib.optionals calibreSupport [ calibre ] ++ lib.optionals ffmpegSupport [ ffmpeg-headless ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lazylibrarian";
  version = "2026.09.19-unstable-2026-11-07";

  src = fetchFromGitLab {
    owner = "LazyLibrarian";
    repo = "LazyLibrarian";
    rev = "8b6ba44398f6c74c4dd29b13dc2047b771e27488";
    hash = "sha256-BMScDw1KHmkc8pT586upBQM6bCPiqmrAc7fwJPhWHyY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  # "package" is upstream's switch for non-upgradeable distro installs, which
  # disables self-updating. An empty unbundled.libs turns off the unbundler,
  # which would otherwise pip install and delete files under the store path.
  postPatch = ''
    substituteInPlace lazylibrarian/version.py \
      --replace-fail 'LAZYLIBRARIAN_VERSION = "master"' 'LAZYLIBRARIAN_VERSION = "package"'
    echo '[]' > unbundled.libs
  '';

  dontBuild = true;

  nativeCheckInputs = [
    python3.pkgs.pytestCheckHook
  ]
  ++ dependencies python3.pkgs
  ++ (with python3.pkgs; [
    mock
    pytest-order
  ]);

  doCheck = true;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  enabledTestPaths = [ "unittests" ];

  disabledTestPaths = [
    "unittests/test_icrawler.py"
  ];

  disabledTests = [
    "test_add_author_name_to_db_UnknownPerson"
  ];

  installPhase = ''
    runHook preInstall

    # Upstream ships a source tree run as `python LazyLibrarian.py`, which finds
    # its templates and images next to itself, rather than an installable package.
    mkdir -p $out/share/lazylibrarian
    cp -r LazyLibrarian.py lazylibrarian lib data unbundled.libs \
      example.* example_* $out/share/lazylibrarian/

    # Avoid datadir being on /nix/store by default.
    makeWrapper ${pythonEnv.interpreter} $out/bin/lazylibrarian \
      --add-flags "$out/share/lazylibrarian/LazyLibrarian.py" \
      --add-flags '--datadir="''${XDG_DATA_HOME:-$HOME/.local/share}/lazylibrarian"' \
      ${lib.optionalString (runtimePath != [ ]) "--prefix PATH : ${lib.makeBinPath runtimePath}"}

    runHook postInstall
  '';

  doInstallCheck = true;
  postInstallCheck = ''
    HOME=$(mktemp -d) $out/bin/lazylibrarian --help > /dev/null
  '';

  passthru = {
    inherit pythonEnv;
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Usenet/BitTorrent ebook, audiobook and magazine downloader";
    homepage = "https://lazylibrarian.gitlab.io/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ xelden ];
    mainProgram = "lazylibrarian";
    platforms = lib.platforms.linux;
  };
})
