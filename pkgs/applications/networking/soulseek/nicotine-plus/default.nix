{ stdenv, fetchFromGitHub, python27Packages, lib
, geoip ? null
, geolite-legacy ? null

# Nicotine+ supports a country code blocker. This requires a (GPL'ed) library called GeoIP.
, enableGeoIP ? true
}:

assert enableGeoIP -> python27Packages.GeoIP != null;
assert enableGeoIP -> geoip                  != null;
assert enableGeoIP -> geolite-legacy         != null;

with stdenv.lib;

python27Packages.buildPythonApplication rec {
  pname = "nicotine-plus";
  version = "1.4.1";
  src = fetchFromGitHub {
    owner = "Nicotine-Plus";
    repo = "nicotine-plus";
    rev = "4e057d64184885c63488d4213ade3233bd33e67b";
    sha256 = "11j2qm67sszfqq730czsr2zmpgkghsb50556ax1vlpm7rw3gm33c";
  };

  propagatedBuildInputs = with python27Packages; [
    pygtk
    miniupnpc
    mutagen
    notify
  ] ++ lib.lists.optional enableGeoIP
     (GeoIP.overrideAttrs (_: {
       propagatedBuildInputs = lib.lists.singleton
         (geoip.override  (_: {
           geoipDatabase = geolite-legacy;
         }));
     }));

  postFixup = "mv $out/bin/nicotine $out/bin/nicotine-plus";

  meta = {
    description = "A graphical client for the SoulSeek peer-to-peer system";
    homepage = https://www.nicotine-plus.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.all;
  };
}
