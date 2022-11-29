{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, python3
, vala
, intltool
, autoreconfHook
, wrapGAppsHook
, lightdm
, gtk3
, pixman
, libcanberra
, libX11
, libXext
, linkFarm
, lightdm-slick-greeter
, numlockx
}:

stdenv.mkDerivation rec {
  pname = "lightdm-slick-greeter";
  version = "1.5.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "slick-greeter";
    rev = version;
    sha256 = "sha256-UEzidH4ZWggcOWHHuAclHbbgATDBdogL99Ze0PlwRoc=";
  };

  nativeBuildInputs = [
    pkg-config
    vala
    intltool
    autoreconfHook
    wrapGAppsHook
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    lightdm
    gtk3
    pixman
    libcanberra
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
      --replace "/usr/bin/slick-greeter" "${placeholder "out"}/bin/slick-greeter"

    substituteInPlace src/session-list.vala \
      --replace "/usr/share" "${placeholder "out"}/share"

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
