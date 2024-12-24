{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream,
  cmake,
  fetchpatch,
  gettext,
  git,
  makeWrapper,
  lsb-release,
  pkg-config,
  wrapGAppsHook3,
  curl,
  sqlite,
  wxGTK32,
  gtk3,
  darwin,
}:

stdenv.mkDerivation rec {
  pname = "money-manager-ex";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "moneymanagerex";
    repo = "moneymanagerex";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-jV1jW0aFx95JpwzywEVajstnMKVcEtBdvyL7y6OLl+k=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/moneymanagerex/moneymanagerex/pull/6716
      name = "workaround-appstream-1.0.3.patch";
      url = "https://github.com/moneymanagerex/moneymanagerex/commit/bb98eab92d95b7315d27f4e59ae59b50587106d8.patch";
      hash = "sha256-98OyFO2nnGBRTIirxZ3jX1NPvsw5kVT8nsCSSmyfabo=";
    })
  ];

  postPatch =
    lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
      substituteInPlace src/platfdep_mac.mm \
        --replace "appearance.name == NSAppearanceNameDarkAqua" "NO"
    ''
    + lib.optionalString (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isx86_64) ''
      substituteInPlace 3rd/CMakeLists.txt \
        --replace "-msse4.2 -maes" ""
    '';

  nativeBuildInputs =
    [
      appstream # for appstreamcli
      cmake
      gettext
      git
      makeWrapper
      pkg-config
      wrapGAppsHook3
      wxGTK32
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      lsb-release
    ];

  buildInputs =
    [
      curl
      sqlite
      wxGTK32
      gtk3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.libobjc
    ];

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-deprecated-copy"
      "-Wno-old-style-cast"
      "-Wno-unused-parameter"
    ]
  );

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/mmex.app $out/Applications
    makeWrapper $out/{Applications/mmex.app/Contents/MacOS,bin}/mmex
  '';

  meta = {
    description = "Easy-to-use personal finance software";
    homepage = "https://www.moneymanagerex.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
    mainProgram = "mmex";
  };
}
