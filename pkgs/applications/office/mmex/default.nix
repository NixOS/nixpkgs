{ lib
, stdenv
, fetchFromGitHub
, cmake
, gettext
, git
, makeWrapper
, lsb-release
, pkg-config
, wrapGAppsHook
, curl
, sqlite
, wxGTK
, gtk3
, libobjc
}:

stdenv.mkDerivation rec {
  pname = "money-manager-ex";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "moneymanagerex";
    repo = "moneymanagerex";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-ADhTz6OMntgDg3TcAlf3lGBFb+fdZ0Lw7+UYYY1RD8M=";
  };

  postPatch = lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    substituteInPlace src/platfdep_mac.mm \
      --replace "appearance.name == NSAppearanceNameDarkAqua" "NO"
  '';

  nativeBuildInputs = [
    cmake
    gettext
    git
    makeWrapper
    pkg-config
    wrapGAppsHook
  ] ++ lib.optionals stdenv.isLinux [
    lsb-release
  ];

  buildInputs = [
    curl
    sqlite
    wxGTK
    gtk3
  ] ++ lib.optionals stdenv.isDarwin [
    libobjc
  ];

  NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [
    "-Wno-old-style-cast"
  ]);

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/mmex.app $out/Applications
    makeWrapper $out/{Applications/mmex.app/Contents/MacOS,bin}/mmex
  '';

  meta = {
    description = "Easy-to-use personal finance software";
    homepage = "https://www.moneymanagerex.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; unix;
    mainProgram = "mmex";
  };
}
