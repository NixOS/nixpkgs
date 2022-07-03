{ fetchFromGitHub, libcommuni, qtbase, qmake, lib, stdenv, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "communi";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "communi";
    repo = "communi-desktop";
    # Without https://github.com/communi/communi-desktop/pull/146 fetching fails with
    #     fatal: unable to connect to github.com:
    #     github.com[0: 140.82.112.3]: errno=Connection timed out
    rev = "5d813dc6e64a623cd5d78f024c8a0720a5155a28";
    hash = "sha256-ci91Bf0EkhlPDO+NcpnMmT/vE41i5RD2mXbRAnMB++M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake ]
    ++ lib.optional stdenv.isDarwin wrapQtAppsHook;

  buildInputs = [ libcommuni qtbase ];

  dontWrapQtApps = true;

  preConfigure = ''
    export QMAKEFEATURES=${libcommuni}/features
  '';

  qmakeFlags = [
    "COMMUNI_INSTALL_PREFIX=${placeholder "out"}"
    "COMMUNI_INSTALL_PLUGINS=${placeholder "out"}/lib/communi/plugins"
    "COMMUNI_INSTALL_ICONS=${placeholder "out"}/share/icons/hicolor"
    "COMMUNI_INSTALL_DESKTOP=${placeholder "out"}/share/applications"
    "COMMUNI_INSTALL_THEMES=${placeholder "out"}/share/communi/themes"
    (if stdenv.isDarwin
      then [ "COMMUNI_INSTALL_BINS=${placeholder "out"}/Applications" ]
      else [ "COMMUNI_INSTALL_BINS=${placeholder "out"}/bin" ])
  ];

  postInstall = if stdenv.isDarwin then ''
    # Nix qmake does not add the bundle rpath by default.
    install_name_tool \
      -add_rpath @executable_path/../Frameworks \
      $out/Applications/Communi.app/Contents/MacOS/Communi
  '' else ''
    substituteInPlace "$out/share/applications/communi.desktop" \
      --replace "/usr/bin" "$out/bin"
  '';

  preFixup = ''
    rm -rf lib
  '';

  meta = with lib; {
    description = "A simple and elegant cross-platform IRC client";
    homepage = "https://github.com/communi/communi-desktop";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hrdinka ];
    platforms = platforms.linux;
  };
}
