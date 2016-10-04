{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, qt5
, menu-cache
, libfm
, elementary-icon-theme
}:

let
  version = "0.11.0";

  buildInputsCommon = [ cmake pkgconfig qt5.qtbase qt5.qttools qt5.qtx11extras menu-cache libfm ];

  libfm-qt = stdenv.mkDerivation rec {
    name    = "${pname}-${version}";
    pname   = "libfm-qt";

    src = fetchFromGitHub {
      owner  = "lxde";
      repo   = pname;
      rev    = version;
      sha256 = "0a8rd0m66l6n2jl7fin74byyy69pyc6rgnfkpmkbi6561l903592";
    };

    buildInputs = buildInputsCommon;
  };

in stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "pcmanfm-qt";

  src = fetchFromGitHub {
    owner  = "lxde";
    repo   = pname;
    rev    = version;
    sha256 = "139l8m32sqcjmydppbv24iqnfsbl5b4rqmqzdayvlh6haf1ihinn";
  };


  buildInputs = buildInputsCommon ++ [ libfm-qt qt5.makeQtWrapper ];

  postPatch = ''
    substituteInPlace pcmanfm/settings.cpp --replace \"elementary\" \"Elementary\"
  '';

  postInstall = ''
    wrapQtProgram $out/bin/pcmanfm-qt \
      --prefix XDG_DATA_DIRS : "${elementary-icon-theme}/share"
  '';

  meta = with stdenv.lib; {
    homepage    = "https://github.com/lxde/pcmanfm-qt";
    license     = licenses.gpl2Plus;
    description = "File manager with QT interface";
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.linux;
  };
}
