{ stdenv, fetchurl, cmake, readline }:

stdenv.mkDerivation rec {
  name = "tasksh-${version}";
  version = "1.2.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://taskwarrior.org/download/${name}.tar.gz";
    sha256 = "1z8zw8lld62fjafjvy248dncjk0i4fwygw0ahzjdvyyppx4zjhkf";
  };

  buildInputs = [ readline ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "REPL for taskwarrior";
    homepage = http://tasktools.org;
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}
