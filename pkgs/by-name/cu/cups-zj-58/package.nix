{
  lib,
  stdenv,
  fetchFromGitHub,
  cups,
}:

stdenv.mkDerivation {
  pname = "cups-zj-58";
  version = "2018-02-22";

  src = fetchFromGitHub {
    owner = "klirichek";
    repo = "zj-58";
    rev = "e4212cd";
    sha256 = "1w2qkspm4qqg5h8n6gmakzhiww7gag64chvy9kf89xsl3wsyp6pi";
  };

  buildInputs = [ cups ];

  installPhase = ''
    install -D rastertozj $out/lib/cups/filter/rastertozj
    install -D ZJ-58.ppd $out/share/cups/model/zjiang/ZJ-58.ppd
  '';

  meta = with lib; {
    description = "CUPS filter for thermal printer Zjiang ZJ-58";
    homepage = "https://github.com/klirichek/zj-58";
    platforms = platforms.linux;
    maintainers = with maintainers; [ makefu ];
    license = licenses.bsd2;
  };
}
