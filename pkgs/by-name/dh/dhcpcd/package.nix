{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  udev,
  freebsd,
  runtimeShellPackage,
  runtimeShell,
  nixosTests,
  enablePrivSep ? false,
}:

stdenv.mkDerivation rec {
  pname = "dhcpcd";
  version = "10.1.0";

  src = fetchFromGitHub {
    owner = "NetworkConfiguration";
    repo = "dhcpcd";
    rev = "v${version}";
    sha256 = "sha256-Qtg9jOFMR/9oWJDmoNNcEAMxG6G1F187HF4MMBJIoTw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [
      runtimeShellPackage # So patchShebangs finds a bash suitable for the installed scripts
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      udev
    ]
    ++ lib.optionals stdenv.hostPlatform.isFreeBSD [
      freebsd.libcapsicum
      freebsd.libcasper
    ];

  postPatch = ''
    substituteInPlace hooks/dhcpcd-run-hooks.in --replace /bin/sh ${runtimeShell}
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-privsep"
    "--dbdir=/var/lib/dhcpcd"
    (lib.enableFeature enablePrivSep "privsep")
  ] ++ lib.optional enablePrivSep "--privsepuser=dhcpcd";

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # Hack to make installation succeed.  dhcpcd will still use /var/lib
  # at runtime.
  installFlags = [
    "DBDIR=$(TMPDIR)/db"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  # Check that the udev plugin got built.
  postInstall = lib.optionalString (
    udev != null && stdenv.hostPlatform.isLinux
  ) "[ -e ${placeholder "out"}/lib/dhcpcd/dev/udev.so ]";

  passthru.tests = {
    inherit (nixosTests.networking.scripted) macvlan dhcpSimple dhcpOneIf;
  };

  meta = with lib; {
    description = "Client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = "https://roy.marples.name/projects/dhcpcd";
    platforms = platforms.linux ++ platforms.freebsd;
    license = licenses.bsd2;
    maintainers = [ ];
    mainProgram = "dhcpcd";
  };
}
