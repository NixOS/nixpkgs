{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, gnome
, libsecret
, git
, curl
, nss
, nspr
, xorg
, libdrm
, alsa-lib
, cups
, mesa
, systemd
}:

stdenv.mkDerivation rec {
  pname = "github-desktop";
  version = "2.9.4";

  src = fetchurl {
    url = "https://github.com/shiftkey/desktop/releases/download/release-${version}-linux1/GitHubDesktop-linux-${version}-linux1.deb";
    sha256 = "sha256-CcAOATIEcrUKhVQWFr0dMvY9Q5rHWQI9/KdSEZ/ncD4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    gnome.gnome-keyring
    xorg.libXdamage
    xorg.libX11
    libsecret
    git
    curl
    nss
    nspr
    libdrm
    alsa-lib
    cups
    mesa
  ];

  unpackPhase = ''
    mkdir -p $TMP/${pname} $out/{opt,bin}
    cp $src $TMP/${pname}.deb
    ar vx ${pname}.deb
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/${pname}/
  '';

  installPhase = ''
    cp -R $TMP/${pname}/usr/share $out/
    cp -R $TMP/${pname}/usr/lib/${pname}/* $out/opt/
    ln -sf $out/opt/${pname} $out/bin/${pname}
  '';

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

  meta = with lib; {
    description = "GUI for managing Git and GitHub.";
    homepage = "https://desktop.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
