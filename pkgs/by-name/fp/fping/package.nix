{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "fping";
  version = "5.3";

  src = fetchurl {
    url = "https://www.fping.org/dist/fping-${version}.tar.gz";
    hash = "sha256-1XvQFBrqCC4638GYv8PbXf0SpwFMfCZV6X9hzVSQHQ4=";
  };

  configureFlags = [
    "--enable-ipv6"
    "--enable-ipv4"
  ];

  meta = with lib; {
    description = "Send ICMP echo probes to network hosts";
    homepage = "http://fping.org/";
    changelog = "https://github.com/schweikert/fping/releases/tag/v${version}";
    license = licenses.bsd0;
    mainProgram = "fping";
    maintainers = with maintainers; [ fab ];
    platforms = platforms.all;
  };
}
