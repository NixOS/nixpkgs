{ lib, stdenv, zlib, glucose }:
stdenv.mkDerivation rec {
  pname = "glucose-syrup";
  version = glucose.version;

  src = glucose.src;

  buildInputs = [ zlib ];

  sourceRoot = "glucose-syrup-${version}/parallel";
  makeFlags = [ "r" ];
  installPhase = ''
    install -Dm0755 glucose-syrup_release $out/bin/glucose-syrup
    mkdir -p "$out/share/doc/${pname}-${version}/"
    install -Dm0755 ../{LICEN?E,README*,Changelog*} "$out/share/doc/${pname}-${version}/"
  '';

  meta = with lib; {
    description = "Modern, parallel SAT solver (parallel version)";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
