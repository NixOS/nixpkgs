{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  meson,
  ninja,
  pkg-config,
  czmq,
  libusb1,
  ncurses,
  SDL2,
  libelf,
}:

let
  libdwarf = fetchzip {
    url = "https://www.prevanders.net/libdwarf-0.7.0.tar.xz";
    hash = "sha256-YTTbBJkDu2BSAVpvucqtg7/hFxXrxLnNAlvAL7rmkdE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "orbuculum";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "orbcode";
    repo = "orbuculum";
    tag = "V${finalAttrs.version}";
    hash = "sha256-n3+cfeN6G9n8pD5WyiHPENMJ0FN+bRVZe9pl81uvIrc=";
  };

  postPatch = ''
    cp --recursive --no-preserve=mode ${libdwarf} subprojects/libdwarf-0.7.0
    pushd subprojects/libdwarf-0.7.0
    patch -p1 < ../packagefiles/libdwarf/0001-fix-Use-project_source_root-for-subproject-compatibi.patch
    patch -p1 < ../packagefiles/libdwarf/0002-fix-compilation-clang.patch
    patch -p1 < ../packagefiles/libdwarf/0003-Fixed-calloc-arguments-order.patch
    popd
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    czmq
    libusb1
    ncurses
    SDL2
    libelf
  ];

  doInstallCheck = true;

  installFlags = [ "INSTALL_ROOT=$(out)/" ];

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d/
    cp $src/Support/60-orbcode.rules $out/etc/udev/rules.d/
  '';

  meta = {
    description = "Cortex M SWO SWV Demux and Postprocess for the ORBTrace";
    homepage = "https://orbcode.org";
    changelog = "https://github.com/orbcode/orbuculum/blob/V${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ newam ];
    platforms = lib.platforms.linux;
  };
})
