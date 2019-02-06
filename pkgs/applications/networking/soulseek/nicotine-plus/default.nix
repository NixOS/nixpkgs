{ stdenv, fetchFromGitHub, python27Packages, lib
, geoip
# Nicotine+ supports a country code blocker. This requires a (GPL'ed) library called GeoIP.
, enableGeoIP ? true
}:

assert enableGeoIP -> python27Packages.GeoIP != null;

with stdenv.lib;
with lists;

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
    ] ++ optional enableGeoIP
     (GeoIP.overrideAttrs (_: {
       propagatedBuildInputs = [geoip];
     }));

  # Insert real docs directory.
  # os.getcwd() is not needed
  postPatch = ''
    substituteInPlace ./pynicotine/gtkgui/frame.py \
      --replace "paths.append(os.getcwd())" "paths.append('"$out"/doc')"
  '';

  postFixup = ''
    mkdir -p $out/doc/
    mv ./doc/NicotinePlusGuide $out/doc/
    mv $out/bin/nicotine $out/bin/nicotine-plus
  '';

  meta = {
    description = "A graphical client for the SoulSeek peer-to-peer system";
    homepage = https://www.nicotine-plus.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ klntsky ];
    platforms = platforms.unix;
  };
}
