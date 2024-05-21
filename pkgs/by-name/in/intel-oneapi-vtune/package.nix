{
  alsa-lib,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  dbus,
  elfutils,
  expat,
  fetchurl,
  file-rename,
  glib,
  gtk3,
  kmod,
  lib,
  libdrm,
  libndctl,
  libsafec,
  libxcrypt-legacy,
  libxkbcommon,
  mesa,
  ncurses5,
  nspr,
  nss,
  opencl-clang,
  p7zip,
  pango,
  stdenv,
  systemd,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "intel-oneapi-vtune";
  version = "2024.1";

  src = fetchurl {
    # To get this URL, download an Online or Offline Installer[1], extract it,
    # and find the URL in the corresponding `manifest.json` file.
    # [1]: https://www.intel.com/content/www/us/en/developer/tools/oneapi/vtune-profiler-download.html
    url = "https://installer.repos.intel.com/oneapi/vtune/lin/intel.oneapi.lin.vtune,v=${finalAttrs.version}.0%2B515/cupPayload.cup";
    hash = "sha256-Ma1/pVfOzeNHOXpD+nudaAIXUzTUg0TLKrzXesEr+0A=";
  };

  nativeBuildInputs = [
    p7zip
    autoPatchelfHook
    file-rename
  ];

  buildInputs = [
    alsa-lib
    atk
    cairo
    cups
    dbus
    elfutils
    expat
    glib
    gtk3
    kmod
    libdrm
    libndctl
    libsafec
    libxcrypt-legacy
    libxkbcommon
    mesa
    ncurses5
    nspr
    nss
    opencl-clang
    pango
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
  ];

  unpackPhase = ''
    runHook preUnpack

    7za x $src _installdir/vtune/${finalAttrs.version}

    # Fix percent-encoded filenames, e.g. "libstdc%2B%2B.so.6" -> "libstdc++.so.6"
    find -depth -name '*%*' -execdir rename 's/%2B/+/g; s/%5B/[/g; s/%5D/]/g' {} \;

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/intel/oneapi
    mv _installdir/vtune $out/opt/intel/oneapi
    ln -s $out/opt/intel/oneapi/vtune/{${finalAttrs.version},latest}

    mkdir -p $out/bin
    for bin in vtune vtune-backend vtune-gui; do
      ln -s $out/opt/intel/oneapi/vtune/${finalAttrs.version}/bin64/$bin $out/bin/
    done

    mkdir -p $out/share/applications
    cp $out/opt/intel/oneapi/vtune/${finalAttrs.version}/bin64/vtune-gui.desktop $out/share/applications/
    sed -i $out/share/applications/vtune-gui.desktop -e "
      s|^Exec=.*|Exec=vtune-gui|g;
      s|^Icon=./|Icon=$out/opt/intel/oneapi/vtune/${finalAttrs.version}/bin64/|g;
    "

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libffi.so.6" # Used in vendored python
    "libgdbm.so.4" # Used in vendored python
    "libgdbm_compat.so.4" # Used in vendored python
    "libsycl.so.7" # Used in bin64/self_check_apps/matrix.dpcpp/matrix.dpcpp
  ];

  runtimeDependencies = [
    systemd # for zygote (vtune-gui)
  ];

  meta = {
    description = "Performance analysis tool for x86-based machines";
    homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/vtune-profiler.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ xzfc ];
    platforms = [ "x86_64-linux" ];
  };
})
