{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  vala,
  intltool,
  autoreconfHook,
  wrapGAppsHook3,
  cinnamon,
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
}:

stdenv.mkDerivation rec {
  pname = "lightdm-slick-greeter";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "slick-greeter";
    rev = version;
    sha256 = "sha256-ROOCxOjqJ8dTZjfQpjmE9oDQJzt6QFVVf3nrJ26mFU8=";
  };

  nativeBuildInputs = [
    pkg-config
    vala
    intltool
    autoreconfHook
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
      --replace "/usr/bin/numlockx" "${numlockx}/bin/numlockx" \
      --replace "/usr/share/xsessions/" "/run/current-system/sw/share/xsessions/" \
      --replace "/usr/share/wayland-sessions/" "/run/current-system/sw/share/wayland-sessions/" \
      --replace "/usr/bin/slick-greeter" "${placeholder "out"}/bin/slick-greeter"

    substituteInPlace src/session-list.vala \
      --replace "/usr/share" "${placeholder "out"}/share"

    # We prefer stable path here.
    substituteInPlace data/x.dm.slick-greeter.gschema.xml \
      --replace "/usr/share/onboard" "/run/current-system/sw/share/onboard"

    patchShebangs files/usr/bin/*
  '';

  preAutoreconf = ''
    # intltoolize fails during autoreconfPhase unless this
    # directory is created manually.
    mkdir m4
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--sbindir=${placeholder "out"}/bin"
  ];

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/slick-greeter.desktop" \
      --replace "Exec=slick-greeter" "Exec=$out/bin/slick-greeter"

    cp -r files/usr/* $out
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
    )
  '';

  passthru.xgreeters = linkFarm "lightdm-slick-greeter-xgreeters" [
    {
      path = "${lightdm-slick-greeter}/share/xgreeters/slick-greeter.desktop";
      name = "lightdm-slick-greeter.desktop";
    }
  ];

  meta = with lib; {
    description = "A slick-looking LightDM greeter";
    homepage = "https://github.com/linuxmint/slick-greeter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      water-sucks
      bobby285271
    ];
    platforms = platforms.linux;
  };
}
