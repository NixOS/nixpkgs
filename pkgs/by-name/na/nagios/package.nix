{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  php,
  gd,
  libpng,
  openssl,
  zlib,
  unzip,
  nixosTests,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nagios";
  version = "4.5.9";

  src = fetchFromGitHub {
    owner = "NagiosEnterprises";
    repo = "nagioscore";
    tag = "nagios-${finalAttrs.version}";
    hash = "sha256-aOHdMZJCrGeJ3XA3+ed3JUb7X1FdfdGiT2ytzBDAT4c=";
  };

  patches = [ ./nagios.patch ];
  nativeBuildInputs = [ unzip ];

  buildInputs = [
    php
    perl
    gd
    libpng
    openssl
    zlib
  ];

  configureFlags = [
    "--localstatedir=/var/lib/nagios"
    "--with-ssl=${openssl.dev}"
    "--with-ssl-inc=${openssl.dev}/include"
    "--with-ssl-lib=${lib.getLib openssl}/lib"
  ];

  buildFlags = [ "all" ];

  # Do not create /var directories
  preInstall = ''
    substituteInPlace Makefile --replace-fail '$(MAKE) install-basic' ""
  '';
  installTargets = "install install-config";
  postInstall = ''
    # don't make default files use hardcoded paths to commands
    sed -i 's@command_line *[^ ]*/\([^/]*\) @command_line \1 @'  $out/etc/objects/commands.cfg
    sed -i 's@/usr/bin/@@g' $out/etc/objects/commands.cfg
    sed -i 's@/bin/@@g' $out/etc/objects/commands.cfg
  '';

  passthru = {
    tests = {
      inherit (nixosTests) nagios;
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        command = "nagios --version";
      };
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "nagios-(.*)"
      ];
    };
  };

  meta = {
    description = "Host, service and network monitoring program";
    homepage = "https://www.nagios.org/";
    changelog = "https://github.com/NagiosEnterprises/nagioscore/blob/nagios-${finalAttrs.version}/Changelog";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "nagios";
    maintainers = with lib.maintainers; [
      immae
      thoughtpolice
      relrod
      anthonyroussel
    ];
  };
})
