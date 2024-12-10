{
  fetchurl,
  lib,
  substituteAll,
  aspellWithDicts,
  at-spi2-core ? null,
  atspiSupport ? true,
  bash,
  glib,
  dconf,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk3,
  hunspell,
  hunspellDicts,
  hunspellWithDicts,
  intltool,
  isocodes,
  libappindicator-gtk3,
  libcanberra-gtk3,
  mousetweaks,
  udev,
  libxkbcommon,
  pkg-config,
  procps,
  python3,
  wrapGAppsHook3,
  xorg,
  yelp,
}:

let

  customHunspell = hunspellWithDicts [
    hunspellDicts.en-us
  ];

  majorVersion = "1.4";

in

python3.pkgs.buildPythonApplication rec {
  pname = "onboard";
  version = "${majorVersion}.1";

  src = fetchurl {
    url = "https://launchpad.net/onboard/${majorVersion}/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "0r9q38ikmr4in4dwqd8m9gh9xjbgxnfxglnjbfcapw8ybfnf3jh1";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit mousetweaks;
    })
    # Allow loading hunspell dictionaries installed in NixOS system path
    ./hunspell-use-xdg-datadirs.patch
  ];

  nativeBuildInputs = [
    gobject-introspection
    intltool
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    bash
    glib
    dconf
    gsettings-desktop-schemas
    gtk3
    hunspell
    isocodes
    libappindicator-gtk3
    libcanberra-gtk3
    libxkbcommon
    mousetweaks
    udev
    xorg.libXtst
    xorg.libxkbfile
  ] ++ lib.optional atspiSupport at-spi2-core;

  pythonPath = with python3.pkgs; [
    dbus-python
    distutils-extra
    pyatspi
    pycairo
    pygobject3
    systemd
  ];

  propagatedUserEnvPkgs = [
    dconf
  ];

  nativeCheckInputs = [
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

  doCheck = false;

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

    substituteInPlace setup.py \
      --replace "/etc" "$out/etc"

    substituteInPlace  ./Onboard/LanguageSupport.py \
      --replace "/usr/share/xml/iso-codes" "${isocodes}/share/xml/iso-codes"

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

  installPhase = ''
    ${python3.interpreter} setup.py install --prefix="$out"

    cp onboard-default-settings.gschema.override.example $out/share/glib-2.0/schemas/10_onboard-default-settings.gschema.override
    glib-compile-schemas $out/share/glib-2.0/schemas/
  '';

  # Remove ubuntu icons.
  postFixup = ''
    rm -rf  $out/share/icons/ubuntu-mono-*
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/onboard";
    description = "Onscreen keyboard useful for tablet PC users and for mobility impaired users";
    maintainers = with maintainers; [ johnramsden ];
    license = licenses.gpl3;
  };
}
