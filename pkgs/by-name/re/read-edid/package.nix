{
  stdenv,
  lib,
  fetchurl,
  cmake,
  libx86,
}:

stdenv.mkDerivation rec {
  pname = "read-edid";
  version = "3.0.2";

  src = fetchurl {
    url = "http://www.polypux.org/projects/read-edid/${pname}-${version}.tar.gz";
    sha256 = "0vqqmwsgh2gchw7qmpqk6idgzcm5rqf2fab84y7gk42v1x2diin7";
  };

  patches = [ ./fno-common.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace 'COPYING' 'LICENSE'
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional stdenv.hostPlatform.isx86 libx86;

  cmakeFlags = [ "-DCLASSICBUILD=${if stdenv.hostPlatform.isx86 then "ON" else "OFF"}" ];

  meta = {
    description = "Tool for reading and parsing EDID data from monitors";
    homepage = "http://www.polypux.org/projects/read-edid/";
    license = lib.licenses.bsd2; # Quoted: "This is an unofficial license. Let's call it BSD-like."
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.linux;
  };
}
