{ fetchurl
, stdenv
, aspellWithDicts
, at-spi2-core ? null
, atspiSupport ? true
, bash
, glib
, glibcLocales
, gnome3
, gobjectIntrospection
, gsettings-desktop-schemas
, gtk3
, hunspell
, hunspellDicts
, hunspellWithDicts
, intltool
, isocodes
, libcanberra-gtk3
, libudev
, libxkbcommon
, pkgconfig
, procps
, python3
, wrapGAppsHook
, xorg
, yelp
}:

let
  customHunspell = hunspellWithDicts [hunspellDicts.en-us];
  majorVersion = "1.4";
  version = "${majorVersion}.1";
in python3.pkgs.buildPythonApplication rec {
  name = "onboard-${version}";
  src = fetchurl {
    url = "https://launchpad.net/onboard/${majorVersion}/${version}/+download/${name}.tar.gz";
    sha256 = "01cae1ac5b1ef1ab985bd2d2d79ded6fc99ee04b1535cc1bb191e43a231a3865";
  };

  patches = [
    # Allow loading hunspell dictionaries installed in NixOS system path
    ./hunspell-use-xdg-datadirs.patch
  ];

  # For tests
  LC_ALL = "en_US.UTF-8";
  doCheck = false;
  checkInputs = [
    # for Onboard.SpellChecker.aspell_cmd doctests
    (aspellWithDicts (dicts: with dicts; [ en ]))

    # for Onboard.SpellChecker.hunspell_cmd doctests
    customHunspell

    # for Onboard.SpellChecker.hunspell doctests
    hunspellDicts.en-us
    hunspellDicts.es-es
    hunspellDicts.it-it

    python3.pkgs.nose
  ];

  propagatedBuildInputs = [
    glib
    python3
    python3.pkgs.dbus-python
    python3.pkgs.distutils_extra
    python3.pkgs.pyatspi
    python3.pkgs.pycairo
    python3.pkgs.pygobject3
    python3.pkgs.systemd
  ];

  buildInputs = [
    bash
    gnome3.dconf
    gsettings-desktop-schemas
    gtk3
    hunspell
    isocodes
    libcanberra-gtk3
    libudev
    libxkbcommon
    wrapGAppsHook
    xorg.libXtst
    xorg.libxkbfile
  ] ++ stdenv.lib.optional atspiSupport at-spi2-core;

  nativeBuildInputs = [
    glibcLocales
    intltool
    pkgconfig
  ];

  propagatedUserEnvPkgs = [
    gnome3.dconf
  ];

  preBuild = ''
    # Unnecessary file, has been removed upstream
    # https://github.com/NixOS/nixpkgs/pull/24986#issuecomment-296114062
    rm -r Onboard/pypredict/attic

    substituteInPlace  ./scripts/sokSettings.py \
      --replace "#!/usr/bin/python3" "" \
      --replace "PYTHON_EXECUTABLE," "\"$out/bin/onboard-settings\"" \
      --replace '"-cfrom Onboard.settings import Settings\ns = Settings(False)"' ""

    chmod -x ./scripts/sokSettings.py

    patchShebangs .

    substituteInPlace  ./Onboard/LanguageSupport.py \
      --replace "/usr/share/xml/iso-codes" "${isocodes}/share/xml/iso-codes" \
      --replace "/usr/bin/yelp" "${yelp}/bin/yelp"

    substituteInPlace  ./Onboard/Indicator.py \
      --replace   "/usr/bin/yelp" "${yelp}/bin/yelp"

    substituteInPlace  ./gnome/Onboard_Indicator@onboard.org/extension.js \
      --replace "/usr/bin/yelp" "${yelp}/bin/yelp"

    substituteInPlace  ./Onboard/SpellChecker.py \
      --replace "/usr/lib" "$out/lib"

    substituteInPlace  ./data/org.onboard.Onboard.service  \
      --replace "/usr/bin" "$out/bin"

    substituteInPlace  ./Onboard/utils.py \
      --replace "/usr/share" "$out/share"
    substituteInPlace  ./onboard-defaults.conf.example \
      --replace "/usr/share" "$out/share"
    substituteInPlace  ./Onboard/Config.py \
      --replace "/usr/share/onboard" "$out/share/onboard"

    substituteInPlace  ./Onboard/WordSuggestions.py \
      --replace "/usr/bin" "$out/bin"

    # killall is dangerous on non-gnu platforms. Use pkill instead.
    substituteInPlace  ./setup.py \
      --replace '"killall",' '"${procps}/bin/pkill", "-x",'
  '';

  postInstall = ''
    cp onboard-default-settings.gschema.override.example $out/share/glib-2.0/schemas/10_onboard-default-settings.gschema.override

    glib-compile-schemas $out/share/glib-2.0/schemas/
  '';

  meta = {
    homepage = https://launchpad.net/onboard;
    description = "An onscreen keyboard useful for tablet PC users and for mobility impaired users.";
    maintainers = with stdenv.lib.maintainers; [ johnramsden ];
    license = stdenv.lib.licenses.gpl3;
  };
}
