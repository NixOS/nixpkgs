{
  lib,
  stdenv,
  fetchFromGitHub,
  cups,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "cups-zj-58";
  version = "0-unstable-2019-04-28";

  src = fetchFromGitHub {
    owner = "klirichek";
    repo = "zj-58";
    rev = "64743565df4379098b68a197d074c86617a8fc0a";
    hash = "sha256-4l9NRfp0hiPDC6dtFsq7jLf0Gn9tktGy6oZ4GHxSfbw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ cups ];

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
    --replace-fail "cmake_minimum_required ( VERSION 3.0 )" "cmake_minimum_required ( VERSION 3.10 )"
  '';

  installPhase = ''
    install -D ppd/zj80.ppd $out/share/cups/model/zjiang/zj80.ppd
    install -D ppd/zj58.ppd $out/share/cups/model/zjiang/zj58.ppd
    install -D rastertozj $out/lib/cups/filter/rastertozj
  '';

  meta = with lib; {
    description = "CUPS filter for thermal printer Zjiang ZJ-58";
    homepage = "https://github.com/klirichek/zj-58";
    platforms = platforms.linux;
    maintainers = with maintainers; [
      makefu
      deimelias
    ];
    license = licenses.bsd2;
  };
}
