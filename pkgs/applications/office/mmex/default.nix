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
, wxGTK32
, gtk3
, darwin
}:

stdenv.mkDerivation rec {
  pname = "money-manager-ex";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "moneymanagerex";
    repo = "moneymanagerex";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-/0gKjkInu2TDe6MJPRLQJrfmk49YcwWSf/Rl9WdJsnk=";
  };

  postPatch = lib.optionalString (stdenv.isDarwin && stdenv.isx86_64) ''
    substituteInPlace src/platfdep_mac.mm \
      --replace "appearance.name == NSAppearanceNameDarkAqua" "NO"
  '' + lib.optionalString (stdenv.isLinux && !stdenv.isx86_64) ''
    substituteInPlace 3rd/CMakeLists.txt \
      --replace "-msse4.2 -maes" ""
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
    wxGTK32
    gtk3
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [
    "-Wno-deprecated-copy"
    "-Wno-old-style-cast"
    "-Wno-unused-parameter"
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
