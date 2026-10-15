{
  stdenv,
  fetchFromGitHub,
  stdenvNoLibc,
  buildPackages,
}:

stdenvNoLibc.mkDerivation {
  pname = "or1k-newlib";
  version = "0-unstable-2018-11-05";

  src = fetchFromGitHub {
    owner = "openrisc";
    repo = "newlib";
    rev = "8ac94ca7bbe4ceddafe6583ee4766d3c15b18ac8";
    hash = "sha256-GqjKgs6YhkG4hRkqFGwdNMqz0bPvitDNvVQXn6uM8EM=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  configurePlatforms = [
    "build"
    "target"
  ];
  configureFlags = [
    "--host=${stdenv.buildPlatform.config}"

    "--disable-newlib-supplied-syscalls"
    "--disable-nls"
    "--enable-newlib-io-long-long"
    "--enable-newlib-register-fini"
    "--enable-newlib-retargetable-locking"
  ];

  dontDisableStatic = true;

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };

  meta = {
    homepage = "https://github.com/openrisc/newlib";
  };
}
