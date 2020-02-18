{ stdenv, lib, fetchFromGitHub, cmake, openssl
, ApplicationServices, Carbon, Cocoa, CoreServices, ScreenSaver
, xlibsWrapper, libX11, libXi, libXtst, libXrandr, xinput, avahi-compat
, withGUI ? true, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "synergy";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "symless";
    repo = "synergy-core";
    rev = "${version}-stable";
    sha256 = "1jk60xw4h6s5crha89wk4y8rrf1f3bixgh5mzh3cq3xyrkba41gh";
  };

  patches = [ ./build-tests.patch
  ] ++ lib.optional stdenv.isDarwin ./macos_build_fix.patch;

  # Since the included gtest and gmock don't support clang and the
  # segfault when built with gcc9, we replace it with 1.10.0 for
  # synergy-1.11.0. This should become unnecessary when upstream
  # updates these dependencies.
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-1.10.0";
    sha256 = "1zbmab9295scgg4z2vclgfgjchfjailjnvzc6f5x9jvlsdi3dpwz";
  };

  postPatch = ''
    rm -r ext/*
    cp -r ${googletest}/googlemock ext/gmock/
    cp -r ${googletest}/googletest ext/gtest/
    chmod -R +w ext/
  '';

  cmakeFlags = lib.optional (!withGUI) "-DSYNERGY_BUILD_LEGACY_GUI=OFF";

  nativeBuildInputs = [ cmake ] ++ lib.optional withGUI wrapQtAppsHook;

  dontWrapQtApps = true;

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices Carbon Cocoa CoreServices ScreenSaver
  ] ++ lib.optionals stdenv.isLinux [
    xlibsWrapper libX11 libXi libXtst libXrandr xinput avahi-compat
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/{synergyc,synergys,synergyd,syntool} $out/bin/
  '' + lib.optionalString withGUI ''
    cp bin/synergy $out/bin/
    wrapQtApp $out/bin/synergy --prefix PATH : ${lib.makeBinPath [ openssl ]}
  '' + lib.optionalString stdenv.isLinux ''
    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp ../res/synergy.svg $out/share/icons/hicolor/scalable/apps/
    mkdir -p $out/share/applications
    substitute ../res/synergy.desktop $out/share/applications/synergy.desktop --replace /usr/bin $out/bin
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications/
    mv bundle/Synergy.app $out/Applications/
    ln -s $out/bin $out/Applications/Synergy.app/Contents/MacOS
  '';

  doCheck = true;
  checkPhase = "bin/unittests";

  meta = with lib; {
    description = "Share one mouse and keyboard between multiple computers";
    homepage = http://synergy-project.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ aszlig enzime ];
    platforms = platforms.all;
  };
}
