{ stdenv, lib, pkgs, python3 }:

with python3.pkgs; buildPythonApplication rec {
  pname = "stig";
  version = "0.10.1a0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xi87kmnyfvdwwx6g6hdgzb6c0jwl98fpvhrg62py80x3j5qlc4a";
  };
  postUnpack = ''
    substituteInPlace stig-${version}/setup.py \
    --replace "urwidtrees>=1.0.3dev0" "urwidtrees"
  '';

  propagatedBuildInputs = [
    urwid
    urwidtrees
    aiohttp
    async-timeout
    pyxdg
    blinker
    natsort
    maxminddb
    setproctitle
  ];
  # Currently, tests fail with:
  # ```
  # TypeError: don't know how to make test from: <stig.client.geoip.GeoIP object at 0x7ffff6594290>
  # ```
  # checkInputs = [
    # asynctest
  # ];
  doCheck = false;

  meta = with lib; {
    description = "TUI and CLI for the BitTorrent client Transmission";
    homepage = "https://github.com/rndusr/stig";
    license = licenses.gpl3;
    maintainers = with maintainers; [ doronbehar ];
  };
}

