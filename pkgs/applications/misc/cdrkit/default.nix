{stdenv, fetchurl, cmake, libcap, zlib}:
stdenv.mkDerivation {
  name = "cdrkit-1.1.6";

  src = fetchurl {
    url = http://cdrkit.org/releases/cdrkit-1.1.6.tar.gz;
    sha256 = "0xb1zqq4s3ylfyzb09s1gpxqr5prhrnpsyycb585ds5p51ymx54r";
  };

  buildInputs = [cmake libcap zlib];

  makeFlags = "PREFIX=\$(out)";

  meta = {
    description = "
CD and DVD writing kit, mostly compatible with cdrtools.
";
  };
}
