{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3,
  vala,
  wrapGAppsHook3,
  lightdm,
  gtk3,
  pixman,
  libcanberra,
  libgnomekbd,
  libX11,
  libXext,
  linkFarm,
  lightdm-slick-greeter,
  numlockx,
  xapp-symbolic-icons,
}:

stdenv.mkDerivation rec {
  pname = "lightdm-slick-greeter";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "slick-greeter";
    rev = version;
    hash = "sha256-htyFH1Q8RFyvkW75NMpjajNJDzv/87k/Dr8+R5beT2w=";
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
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  passthru.xgreeters = linkFarm "lightdm-slick-greeter-xgreeters" [
    {
      path = "${lightdm-slick-greeter}/share/xgreeters/slick-greeter.desktop";
      name = "lightdm-slick-greeter.desktop";
    }
  ];

  meta = with lib; {
    description = "Slick-looking LightDM greeter";
    homepage = "https://github.com/linuxmint/slick-greeter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      water-sucks
      bobby285271
    ];
    platforms = platforms.linux;
  };
}
