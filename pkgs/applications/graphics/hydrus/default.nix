{ stdenv
, fetchFromGitHub
, lzma
, qt5
, wrapQtAppsHook
, miniupnpc_2
, swftools
, pythonPackages
}:

pythonPackages.buildPythonPackage {
  pname = "hydrus";
  version = "413";
  format = "other";

  src = fetchFromGitHub {
    owner = "hydrusnetwork";
    repo = "hydrus";
    rev = "9fbed11bef499e01a6799b298bea7d0967d30430";
    sha256 = "1dl7qpzmlxl376lzm0chmwvf4nl55wz6fwcsw0ikb33rm8r33gq4";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with pythonPackages; [
    beautifulsoup4
    html5lib
    lxml
    numpy
    opencv4
    pillow
    psutil
    pyopenssl
    pyyaml
    requests
    send2trash
    service-identity
    twisted
    lz4
    lzma
    pysocks
    matplotlib
    qtpy
    pyside2
  ];

  checkInputs = with pythonPackages; [ nose httmock ];

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
    -e TestHydrusNATPunch \
    -e TestHydrusSerialisable \
    -e TestHydrusServer \
    -e TestHydrusSessions \
    -e TestServer \
  '';

  extraOutputsToLink = [ "doc" ];

  postPatch = ''
    sed 's;os\.path\.join(\sHC\.BIN_DIR,.*;"${miniupnpc_2}/bin/upnpc";' \
      -i ./hydrus/core/HydrusNATPunch.py

    sed 's;os\.path\.join(\sHC\.BIN_DIR,.*;"${swftools}/bin/swfrender";' \
      -i ./hydrus/core/HydrusFlashHandling.py
  '';

  #doCheck = true;

  installPhase = ''
    # Move the hydrus module and related directories
    mkdir -p $out/${pythonPackages.python.sitePackages}
    mv {hydrus,static} $out/${pythonPackages.python.sitePackages}
    mv help $out/doc/

    # install the hydrus binaries
    mkdir -p $out/bin
    install -m0755 server.py $out/bin/hydrus-server
    install -m0755 client.py $out/bin/hydrus-client
  '';

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with stdenv.lib; {
    description = "Danbooru-like image tagging and searching system for the desktop";
    license = licenses.wtfpl;
    homepage = "https://hydrusnetwork.github.io/hydrus/";
    maintainers = [ maintainers.evanjs ];
  };
}
