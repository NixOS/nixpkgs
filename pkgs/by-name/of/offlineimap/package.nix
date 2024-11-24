{ lib
, fetchFromGitHub
, python3
, asciidoc
, cacert
, docbook_xsl
, installShellFiles
, libxml2
, libxslt
, testers
, offlineimap
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "offlineimap";
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap3";
    rev = "v${version}";
    hash = "sha256-XLxKqO5OCXsFu8S3lMp2Ke5hp6uer9npZ3ujmL6Kb3g=";
  };

  patches = [
    (fetchpatch {
      name = "sqlite-version-aware-threadsafety-check.patch";
      url = "https://github.com/OfflineIMAP/offlineimap3/pull/139/commits/7cd32cf834b34a3d4675b29bebcd32dc1e5ef128.patch";
      hash = "sha256-xNq4jFHMf9XZaa9BFF1lOzZrEGa5BEU8Dr+gMOBkJE4=";
    })
    (fetchpatch {
      # https://github.com/OfflineIMAP/offlineimap3/pull/120
      name = "python312-comaptibility.patch";
      url = "https://github.com/OfflineIMAP/offlineimap3/commit/a1951559299b297492b8454850fcfe6eb9822a38.patch";
      hash = "sha256-CBGMHi+ZzOBJt3TxBf6elrTRMIQ+8wr3JgptL2etkoA=";
     })
    (fetchpatch {
      # https://github.com/OfflineIMAP/offlineimap3/pull/161
      name = "python312-compatibility.patch";
      url = "https://github.com/OfflineIMAP/offlineimap3/commit/3dd8ebc931e3f3716a90072bd34e50ac1df629fa.patch";
      hash = "sha256-2IJ0yzESt+zk+r+Z+9js3oKhFF0+xok0xK8Jd3G/gYY=";
     })
  ];

  postPatch = ''
    # Skip xmllint to stop failures due to no network access
    sed -i docs/Makefile -e "s|a2x -v -d |a2x -L -v -d |"

    # Provide CA certificates (Used when "sslcacertfile = OS-DEFAULT" is configured")
    sed -i offlineimap/utils/distro_utils.py -e '/def get_os_sslcertfile():/a\ \ \ \ return "${cacert}/etc/ssl/certs/ca-bundle.crt"'
  '';

  build-system = [ python3.pkgs.setuptools ];

  nativeBuildInputs = [
    asciidoc
    docbook_xsl
    installShellFiles
    libxml2
    libxslt
  ];

  dependencies = with python3.pkgs; [
    certifi
    distro
    imaplib2
    pysocks
    rfc6555
    urllib3
  ];

  postInstall = ''
    make -C docs man
    installManPage docs/offlineimap.1
    installManPage docs/offlineimapui.7
  '';

  # Test requires credentials
  doCheck = false;

  pythonImportsCheck = [
    "offlineimap"
  ];

  passthru.tests.version = testers.testVersion { package = offlineimap; };

  meta = with lib; {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = "http://offlineimap.org";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "offlineimap";
  };
}
