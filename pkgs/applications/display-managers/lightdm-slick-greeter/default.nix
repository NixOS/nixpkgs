{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook3
, cinnamon
, lightdm
, gtk3
, pixman
, libcanberra
, libgnomekbd
, libX11
, libXext
, linkFarm
, lightdm-slick-greeter
, numlockx
}:

stdenv.mkDerivation rec {
  pname = "lightdm-slick-greeter";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "slick-greeter";
    rev = version;
    sha256 = "sha256-1UOODak5YkoMLdIkN1rBIrlr3Zjj5SS2yx90vmF1prA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    cinnamon.xapp
    lightdm
    gtk3
    pixman
    libcanberra
    libgnomekbd # needed by XApp.KbdLayoutController
    libX11
    libXext
  ];

  pythonPath = [
    python3.pkgs.pygobject3 # for slick-greeter-check-hidpi
  ];

  postPatch = ''
    substituteInPlace src/slick-greeter.vala \
      --replace-fail "/usr/bin/numlockx" "${numlockx}/bin/numlockx" \
      --replace-fail "/usr/share/xsessions/" "/run/current-system/sw/share/xsessions/" \
      --replace-fail "/usr/share/wayland-sessions/" "/run/current-system/sw/share/wayland-sessions/" \
      --replace-fail "/usr/bin/slick-greeter" "${placeholder "out"}/bin/slick-greeter"

    substituteInPlace src/session-list.vala \
      --replace-fail "/usr/share" "${placeholder "out"}/share"

    # We prefer stable path here.
    substituteInPlace data/x.dm.slick-greeter.gschema.xml \
      --replace-fail "/usr/share/onboard" "/run/current-system/sw/share/onboard"

    patchShebangs files/usr/bin/*
  '';

  mesonFlags = [
    "--sbindir=${placeholder "out"}/bin"
  ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/slick-greeter.desktop" \
      --replace-fail "Exec=slick-greeter" "Exec=$out/bin/slick-greeter"
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
    )
  '';

  passthru.xgreeters = linkFarm "lightdm-slick-greeter-xgreeters" [{
    path = "${lightdm-slick-greeter}/share/xgreeters/slick-greeter.desktop";
    name = "lightdm-slick-greeter.desktop";
  }];

  meta = with lib; {
    description = "A slick-looking LightDM greeter";
    homepage = "https://github.com/linuxmint/slick-greeter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ water-sucks bobby285271 ];
    platforms = platforms.linux;
  };
}
