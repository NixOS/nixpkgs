{ stdenv
, lightdm_gtk_greeter
, fetchurl
, lightdm
, pkgconfig
, intltool
, linkFarm
, wrapGAppsHook
, useGTK2 ? false
, gtk2
, gtk3 # gtk3 seems better supported
, exo
, at-spi2-core
, librsvg
, hicolor-icon-theme
}:

#ToDo: bad icons with gtk2;
#  avatar icon is missing in standard hicolor theme, I don't know where gtk3 takes it from

let
  ver_branch = "2.0";
  version = "2.0.7";
in
stdenv.mkDerivation rec {
  pname = "lightdm-gtk-greeter";
  inherit version;

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "1g7wc3d3vqfa7mrdhx1w9ywydgjbffla6rbrxq9k3sc62br97qms";
  };

  nativeBuildInputs = [ pkgconfig intltool wrapGAppsHook ];
  buildInputs = [ lightdm exo librsvg hicolor-icon-theme ]
    ++ (if useGTK2 then [ gtk2 ] else [ gtk3 ]);

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-indicator-services-command"
    "--sbindir=${placeholder "out"}/bin" # for wrapGAppsHook to wrap automatically
  ] ++ stdenv.lib.optional useGTK2 "--with-gtk2";

  preConfigure = ''
    configureFlagsArray+=( --enable-at-spi-command="${at-spi2-core}/libexec/at-spi-bus-launcher --launch-immediately" )
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  installFlags = [
    "localstatedir=\${TMPDIR}"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    substituteInPlace "$out/share/xgreeters/lightdm-gtk-greeter.desktop" \
      --replace "Exec=lightdm-gtk-greeter" "Exec=$out/bin/lightdm-gtk-greeter"
  '';

  passthru.xgreeters = linkFarm "lightdm-gtk-greeter-xgreeters" [{
    path = "${lightdm_gtk_greeter}/share/xgreeters/lightdm-gtk-greeter.desktop";
    name = "lightdm-gtk-greeter.desktop";
  }];

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/lightdm-gtk-greeter;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles ];
  };
}
