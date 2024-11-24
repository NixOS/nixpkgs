{ lib, stdenv, fetchFromGitHub, fontforge, python3 }:

stdenv.mkDerivation rec {
  pname = "rictydiminished-with-firacode";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "hakatashi";
    repo = "RictyDiminished-with-FiraCode";
    rev = version;
    hash = "sha256-twh3yLAM4MUjWzSDNmo8gNIRf01hieXeOS334sNdFk4=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Make builds more reproducible
    substituteInPlace apply-feature.py --replace \
      'ricty = ttLib.TTFont(options.in_font)' \
      'ricty = ttLib.TTFont(options.in_font, recalcTimestamp=False)'
    substituteInPlace build.py --replace \
      'datetime.date.today()' \
      'datetime.date.fromtimestamp(float(os.environ["SOURCE_DATE_EPOCH"]))'
  '';

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/rictydiminished-with-firacode *.ttf

    runHook postInstall
  '';

  nativeBuildInputs = [
    (python3.withPackages (ps: [
      ps.jinja2
      ps.fonttools
      ps.fontforge
    ]))
  ];

  meta = with lib; {
    homepage = "https://github.com/hakatashi/RictyDiminished-with-FiraCode";
    description = "Best Japanese programming font meets the awesome ligatures of Firacode";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ mt-caret ];
  };
}

