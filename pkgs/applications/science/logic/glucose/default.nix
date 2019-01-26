{ stdenv, fetchurl, zlib }:
stdenv.mkDerivation rec {
  name = "glucose-${version}";
  version = "4.1";

  src = fetchurl {
    url = "http://www.labri.fr/perso/lsimon/downloads/softwares/glucose-syrup-${version}.tgz";
    sha256 = "0aahrkaq7n0z986fpqz66yz946nxardfi6dh8calzcfjpvqiraji";
  };

  buildInputs = [ zlib ];

  sourceRoot = "glucose-syrup-${version}/simp";
  makeFlags = [ "r" ];
  installPhase = ''
    install -Dm0755 glucose_release $out/bin/glucose
    mkdir -p "$out/share/doc/${name}/"
    install -Dm0755 ../{LICEN?E,README*,Changelog*} "$out/share/doc/${name}/"
  '';

  meta = with stdenv.lib; {
    description = "Modern, parallel SAT solver (sequential version)";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
    # Build uses _FPU_EXTENDED macro
    badPlatforms = [ "aarch64-linux" ];
  };
}
