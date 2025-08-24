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
  # Always tries to do dynamic linking for udev.
  withUdev ? stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isStatic,
  enablePrivSep ? false,
}:

stdenv.mkDerivation rec {
  pname = "dhcpcd";
  version = "10.2.4";

  src = fetchFromGitHub {
    owner = "NetworkConfiguration";
    repo = "dhcpcd";
    rev = "v${version}";
    sha256 = "sha256-ysaKgF4Cu/S6yhSn/4glA0+Ey54KNp3/1Oh82yE0/PY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    runtimeShellPackage # So patchShebangs finds a bash suitable for the installed scripts
  ]
  ++ lib.optionals withUdev [
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
    "--with-default-hostname=nixos"
    (lib.enableFeature enablePrivSep "privsep")
  ]
  ++ lib.optional enablePrivSep "--privsepuser=dhcpcd";

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # Hack to make installation succeed.  dhcpcd will still use /var/lib
  # at runtime.
  installFlags = [
    "DBDIR=$(TMPDIR)/db"
    "SYSCONFDIR=${placeholder "out"}/etc"
  ];

  # Check that the udev plugin got built.
  postInstall = lib.optionalString withUdev "[ -e ${placeholder "out"}/lib/dhcpcd/dev/udev.so ]";

  passthru.tests = {
    inherit (nixosTests.networking.scripted)
      macvlan
      dhcpSimple
      dhcpHostname
      dhcpOneIf
      ;
  };

  meta = with lib; {
    description = "Client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = "https://roy.marples.name/projects/dhcpcd";
    platforms = platforms.linux ++ platforms.freebsd ++ platforms.openbsd;
    license = licenses.bsd2;
    maintainers = [ ];
    mainProgram = "dhcpcd";
  };
}
