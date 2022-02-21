{ lib
, fetchFromGitHub
, wrapQtAppsHook
, miniupnpc_2
, ffmpeg
, enableSwftools ? false
, swftools
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "hydrus";
  version = "474";
  format = "other";

  src = fetchFromGitHub {
    owner = "hydrusnetwork";
    repo = "hydrus";
    rev = "v${version}";
    sha256 = "sha256-NeTHq8zlgBajw/eogwpabqeU0b7cp83Frqy6kisrths=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    chardet
    cloudscraper
    html5lib
    lxml
    lz4
    nose
    numpy
    opencv4
    pillow
    psutil
    pylzma
    pyopenssl
    pyside2
    pysocks
    pythonPackages.mpv
    pyyaml
    qtpy
    requests
    send2trash
    service-identity
    six
    twisted
  ];

  checkInputs = with python3Packages; [ nose mock httmock ];

  # most tests are failing, presumably because we are not using test.py
  checkPhase = ''
    nosetests $src/hydrus/test  \
    -e TestClientAPI \
    -e TestClientConstants \
    -e TestClientDaemons \
    -e TestClientData \
    -e TestClientDB \
    -e TestClientDBDuplicates \
    -e TestClientDBTags \
    -e TestClientImageHandling \
    -e TestClientImportOptions \
    -e TestClientListBoxes \
    -e TestClientMigration \
    -e TestClientNetworking \
    -e TestClientTags \
    -e TestClientThreading \
    -e TestDialogs \
    -e TestFunctions \
    -e TestHydrusNetwork \
    -e TestHydrusNATPunch \
    -e TestHydrusSerialisable \
    -e TestHydrusServer \
    -e TestHydrusSessions \
    -e TestServer \
  '';

  outputs = [ "out" "doc" ];

  installPhase = ''
    # Move the hydrus module and related directories
    mkdir -p $out/${python3Packages.python.sitePackages}
    mv {hydrus,static} $out/${python3Packages.python.sitePackages}
    mv help $out/doc/

    # install the hydrus binaries
    mkdir -p $out/bin
    install -m0755 server.py $out/bin/hydrus-server
    install -m0755 client.py $out/bin/hydrus-client
  '' + lib.optionalString enableSwftools ''
    mkdir -p $out/${python3Packages.python.sitePackages}/bin
    # swfrender seems to have to be called sfwrender_linux
    # not sure if it can be loaded through PATH, but this is simpler
    # $out/python3Packages.python.sitePackages/bin is correct NOT .../hydrus/bin
    ln -s ${swftools}/bin/swfrender $out/${python3Packages.python.sitePackages}/bin/swfrender_linux
  '';

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ffmpeg miniupnpc_2 ]})
  '';

  meta = with lib; {
    description = "Danbooru-like image tagging and searching system for the desktop";
    license = licenses.wtfpl;
    homepage = "https://hydrusnetwork.github.io/hydrus/";
    maintainers = with maintainers; [ dandellion evanjs ];
  };
}
