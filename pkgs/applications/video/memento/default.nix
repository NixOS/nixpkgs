{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  wrapQtAppsHook,

  # before that => zeal
  sqlite,
  json_c,
  libzip,
  mpv,
  yt-dlp,
  makeWrapper,
  qcoro,
  withOcr ? false,
  python3,
}:
let
  libmocr = stdenv.mkDerivation {
    pname = "libmocr";
    version = "unstable-2023-11-15"; # Placeholder version

    src = fetchFromGitHub {
      owner = "ripose-jp";
      repo = "libmocr";
      rev = "24ec081102208d0ff6954c3003df2fb691713bd5";
      hash = "sha256-58W/LBJ+wIxQtutoXqq6TzpExbUBV3NfAfXTIl43ARg=";
    };

    nativeBuildInputs = [ cmake ];
    buildInputs = [
      qt6.qtbase
      python3
    ];
    dontWrapQtApps = true;
    meta = with lib; {
      description = "A library for Manga OCR";
      homepage = "https://github.com/ripose-jp/libmocr";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "memento";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ripose-jp";
    repo = "Memento";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ipzorykt9GoGTHTTLCyDf7vXx9mT5AITKA9pyQ3GwI=";
  };

  cmakeFlags = [
    (lib.cmakeBool "SYSTEM_QCORO" true)
    (lib.cmakeBool "SYSTEM_MOCR" true)
  ]
  ++ lib.optionals withOcr [
    (lib.cmakeBool "OCR_SUPPORT" true)
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    sqlite
    json_c
    libzip
    qcoro
  ]

  ++ lib.optionals withOcr [ libmocr ];

  propagatedBuildInputs = [ mpv ];

  preFixup =
    let
      pyEnv = python3.withPackages (p: [
        p.manga-ocr
        p.jaconv
      ]);
    in
    ''
      wrapProgram "$out/bin/memento" \
        --prefix PATH : "${yt-dlp}/bin" ${lib.optionalString withOcr "--suffix PYTHONPATH : \"${pyEnv}/${pyEnv.sitePackages}\""}
    '';

  passthru.libmocr = libmocr;

  meta = {
    description = "Mpv-based video player for studying Japanese";
    homepage = "https://ripose-jp.github.io/Memento/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ teto ];
    platforms = lib.platforms.linux;
    mainProgram = "memento";
  };
})
