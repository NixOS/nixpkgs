{
  lib,
  stdenv,
  fetchFromGitHub,
  tor,
  firejail,
  iptables,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "orjail";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "orjail";
    repo = "orjail";
    rev = "v${version}";
    sha256 = "06bwqb3l7syy4c1d8xynxwakmdxvm3qfm8r834nidsknvpdckd9z";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    patchShebangs make-helper.bsh
    mkdir bin
    mv usr/sbin/orjail bin/orjail
    rm -r usr
  '';

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  postInstall = ''
    # Specify binary paths: tor, firejail, iptables
    # mktemp fails with /tmp path prefix, will work without it anyway
    # https://github.com/orjail/orjail/issues/78
    # firejail will fail reading /etc/hosts, therefore remove --hostname arg
    # https://github.com/netblue30/firejail/issues/2758
    substituteInPlace $out/bin/orjail \
      --replace ''$'TORBIN=\n' ''$'TORBIN=${tor}/bin/tor\n' \
      --replace ''$'FIREJAILBIN=\n' ''$'FIREJAILBIN=${firejail}/bin/firejail\n' \
      --replace 'iptables -' '${iptables}/bin/iptables -' \
      --replace 'mktemp /tmp/' 'mktemp ' \
      --replace '--hostname=host ' ""
  '';

  meta = with lib; {
    description = "Force programs to exclusively use tor network";
    mainProgram = "orjail";
    homepage = "https://github.com/orjail/orjail";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}
