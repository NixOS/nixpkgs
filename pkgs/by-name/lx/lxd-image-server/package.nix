{
  lib,
  openssl,
  rsync,
  python3,
  fetchFromGitHub,
  nixosTests,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lxd-image-server";
  version = "0.0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Avature";
    repo = "lxd-image-server";
    rev = version;
    sha256 = "yx8aUmMfSzyWaM6M7+WcL6ouuWwOpqLzODWSdNgwCwo=";
  };

  patches = [
    ./state.patch
    ./run.patch
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    setuptools # pkg_resources is imported during runtime
    attrs
    click
    inotify
    cryptography
    confight
    python-pidfile
  ];

  makeWrapperArgs = [
    ''--prefix PATH ':' "${
      lib.makeBinPath [
        openssl
        rsync
      ]
    }"''
  ];

  doCheck = false;

  pythonImportsCheck = [ "lxd_image_server" ];

  passthru.tests.lxd-image-server = nixosTests.lxd-image-server;

  meta = with lib; {
    description = "Creates and manages a simplestreams lxd image server on top of nginx";
    homepage = "https://github.com/Avature/lxd-image-server";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "lxd-image-server";
  };
}
