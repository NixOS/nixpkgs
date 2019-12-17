{ stdenv, fetchFromGitHub, python3, which, dmd, ldc, zlib }:

stdenv.mkDerivation rec {
  pname = "sambamba";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "biod";
    repo = "sambamba";
    rev = "v${version}";
    sha256 = "0k5wy06zrbsc40x6answgz7rz2phadyqwlhi9nqxbfqanbg9kq20";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ which python3 dmd ldc ];
  buildInputs = [ zlib ];

  # Upstream's install target is broken; copy manually
  installPhase = ''
    mkdir -p $out/bin
    cp bin/sambamba-${version} $out/bin/sambamba
  '';

  meta = with stdenv.lib; {
    description = "SAM/BAM processing tool";
    homepage = "https://lomereiter.github.io/sambamba/";
    maintainers = with maintainers; [ jbedo ];
    license = with licenses; gpl2;
    platforms = platforms.x86_64;
  };
}
