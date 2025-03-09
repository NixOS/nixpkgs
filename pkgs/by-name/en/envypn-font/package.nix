{
  lib,
  stdenv,
  fetchurl,
  libfaketime,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "envypn-font";
  version = "1.7.1";

  src = fetchurl {
    url = "https://ywstd.fr/files/p/envypn-font/envypn-font-${version}.tar.gz";
    sha256 = "bda67b6bc6d5d871a4d46565d4126729dfb8a0de9611dae6c68132a7b7db1270";
  };

  nativeBuildInputs = [
    libfaketime
    xorg.fonttosfnt
    xorg.mkfontscale
  ];

  unpackPhase = ''
    tar -xzf $src --strip-components=1
  '';

  buildPhase = ''
    runHook preBuild

    # convert pcf fonts to otb
    for i in *e.pcf.gz; do
      faketime -f "1970-01-01 00:00:01" \
      fonttosfnt -v -o "$(basename "$i" .pcf.gz)".otb "$i"
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 644 -t "$out/share/fonts/misc" *.otb *.pcf.gz
    mkfontdir "$out/share/fonts/misc"

    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      Readable bitmap font inspired by Envy Code R
    '';
    homepage = "http://ywstd.fr/p/pj/#envypn";
    license = licenses.miros;
    platforms = platforms.all;
    maintainers = with maintainers; [ erdnaxe ];
  };
}
