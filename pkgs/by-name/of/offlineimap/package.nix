{
  lib,
  fetchFromGitHub,
  python3,
  asciidoc,
  cacert,
  docbook_xsl,
  installShellFiles,
  libxml2,
  libxslt,
  testers,
  offlineimap,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "offlineimap";
  version = "8.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap3";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mysvqltO4x2dD8V+FAGOnDw5lQ8bgDwXFK9n15fbUdI=";
  };

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
    gssapi
    imaplib2
    keyring
    portalocker
    pysocks
    rfc6555
    urllib3
  ];

  postInstall = ''
    make -C docs man
    installManPage docs/offlineimap.1
    installManPage docs/offlineimapui.7
    install -Dm644 offlineimap.conf -T $out/share/offlineimap/offlineimap.conf
    install -Dm644 offlineimap.conf.minimal -T $out/share/offlineimap/offlineimap.conf.minimal
  '';

  # Test requires credentials
  doCheck = false;

  pythonImportsCheck = [
    "offlineimap"
  ];

  passthru.tests.version = testers.testVersion { package = offlineimap; };

  meta = {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = "http://offlineimap.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ stephen-huan ];
    mainProgram = "offlineimap";
  };
})
