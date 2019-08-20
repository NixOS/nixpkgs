{ mkDerivation, stdenv, lib, fetchFromGitHub
, qtbase, extra-cmake-modules, cpp-utilities, qtutilities
, cmake, kio, plasma-framework, qttools
, webviewProvider ? null
, jsProvider ? null
, enableKioPluginSupport ? false
, enablePlasmoidSupport  ? false
, systemdSupport ? true }:

mkDerivation rec {
  version = "0.9.1";
  pname = "syncthingtray";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "syncthingtray";
    rev = "v${version}";
    sha256 = "0ijwpwlwwbfh9fdfbwz6dgi6hpmaav2jm56mzxm6as50iwnb59fx";
  };

  buildInputs = [ qtbase cpp-utilities qtutilities webviewProvider jsProvider ] 
    ++ lib.optionals enableKioPluginSupport [ kio ]
    ++ lib.optionals enablePlasmoidSupport [ extra-cmake-modules plasma-framework ]
  ;

  nativeBuildInputs = [ cmake qttools ];

  cmakeFlags = lib.optionals (!enablePlasmoidSupport) ["-DNO_PLASMOID=ON"]
    ++ lib.optionals (!enableKioPluginSupport) ["-DNO_FILE_ITEM_ACTION_PLUGIN=ON"]
    ++ lib.optionals systemdSupport ["-DSYSTEMD_SUPPORT=ON"]
  ;
  # Without this hook, `make install` fails since it tries to write to ${qtbase.out}/lib/qt-<version>/...
  # This is kind of ugly, but it works and it'll probably be quicker than to
  # bother the author of this program as he's using arch Linux and he'll probably be surprised that we
  # modify the prefix of our packages and not using `make DESTDIR= install`.
  preInstall = ''
    echo grepping for ${qtbase.out} as \$qtbase in install files inside the build directory
    grep -l -R ${qtbase.out}/lib/qt- | while read f; do
      substituteInPlace $f --replace ${qtbase.out} $out
    done || :
  '';

  meta = with lib; {
    homepage = "https://github.com/Martchus/syncthingtray";
    description = "Tray application and Dolphin/Plasma integration for Syncthing";
    license = licenses.gpl2;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
