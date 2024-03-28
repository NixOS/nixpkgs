{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, python3
, fontforge
, unar
}: let
  mgensrc = fetchurl {
    url = "https://ftp.iij.ad.jp/pub/osdn.jp/users/8/8599/rounded-x-mgenplus-20150602.7z";
    hash = "sha256-xgQnp1Az/ML57lZF337c9MPZFRnZaGALgxXF9qTlAl0=";
  };
  fantasquesrc = fetchurl {
    url = "https://fontlibrary.org/assets/downloads/fantasque-sans-mono/b0cbb25e73a9f8354e96d89524f613e7/fantasque-sans-mono.zip";
    hash = "sha256-a7OyRBO3ju0Z/6m9IzrlVZguOxhb0wPlfdHgW+vxc1I=";
  };
  notosrc = fetchurl {
    url = "https://fonts.google.com/download?family=Noto%20Emoji";
    hash = "sha256-092mGv0FRdn+827QD+TxlOk+KY8kpdbe0k459NtleaQ=";
  };
  isfitsrc = fetchurl {
    url = "https://github.com/uwabami/isfit-plus/raw/master/dists/isfit-plus.ttf";
    hash = "sha256-evL7bpTxTsReyrhKMqdp/fe4bus1EEVDi2FheyZzRlw=";
  };
in
stdenv.mkDerivation rec {
  pname = "fsmrmp";
  version = "2023-08-24";

  src = fetchFromGitHub {
    owner = "uwabami";
    repo = "fsmrmp";
    rev = "1615d02332df4a3879b6b9fd1ac7a08dd861ba20";
    hash = "sha256-B6VEkBxcoC2E1H4L6jlmT4deYgz2VmEMsQRvNjG36yA=";
  };

  nativeBuildInputs = [
    python3
    fontforge
    unar
  ];

  buildPhase = ''
    mkdir -p tmp sourceFonts dists
    unar ${mgensrc} -o rounded-x-mgenplus
    cp -v rounded-x-mgenplus/*/rounded-x-mgenplus-1mn*.ttf sourceFonts/
    unar ${fantasquesrc} -o fantasque-sans-mono
    cp -v fantasque-sans-mono/*/*.ttf sourceFonts/
    unar ${notosrc} -o noto-emoji
    cp -v noto-emoji/*/static/NotoEmoji-Regular.ttf sourceFonts/
    cp -v ${isfitsrc} sourceFonts/isfit-plus.ttf
    find ${python3.withPackages (pp: [ pp.fontforge ])}
    PYTHONPATH=$PWD/scripts ${python3.withPackages (pp: [ pp.fontforge ])}/bin/python3 -c "import sys; import build; sys.exit(build.build('${version}'))"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dists/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/uwabami/fsmrmp";
    description = "A patched font combining Fantasque Sans Mono, Rounded Mgen+, Noto Emoji (mono) and isfit+ icons";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.rayne ];
  };
}
