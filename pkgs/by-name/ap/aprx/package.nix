{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation {
  pname = "aprx";
  version = "2.9.1-unstable-2021-09-21";

  src = fetchFromGitHub {
    owner = "PhirePhly";
    repo = "aprx";
    rev = "2c84448fe6d897980234961a87ee4c1d4fad69ec";
    sha256 = "sha256-01PB7FaG8GmPm1U15/3g1CfQwdYmf3ThZFdVh2zUAl4=";
  };

  nativeBuildInputs = [ perl ];

  env.NIX_CFLAGS_COMPILE = toString (
    [
      "-fcommon"
      "-O2"
    ]
    ++ lib.optional stdenv.cc.isClang "-Wno-error=implicit-int"
  );

  configureFlags = [
    "--with-erlangstorage"
    "--sbindir=$(out)/bin"
    "--sysconfdir=$(out)/etc"
    "--mandir=$(out)/share/man"
  ];

  makeFlags = [ "INSTALL=install" ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man8 $out/etc
  '';

  meta = with lib; {
    description = "Multitalented APRS i-gate / digipeater";
    homepage = "http://thelifeofkenneth.com/aprx";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sarcasticadmin ];
    mainProgram = "aprx";
    platforms = platforms.unix;
  };
}
