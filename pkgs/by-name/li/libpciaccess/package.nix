{
  lib,
  stdenv,
  fetchurl,
  testers,
  writeScript,
  pkg-config,
  meson,
  ninja,
  zlib,
  netbsd,
  hwdata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libpciaccess";
  version = "0.18.1";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libpciaccess-${finalAttrs.version}.tar.xz";
    hash = "sha256-SvQ0RLOK21VF0O0cLORtlgjMR7McI4f8UYFlZ2Wm+nY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isNetBSD [
    netbsd.libarch
    netbsd.libpci
  ];

  mesonFlags = [
    (lib.mesonOption "pci-ids" "${hwdata}/share/hwdata")
    (lib.mesonEnable "zlib" true)
  ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts

      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"

      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Generic PCI access library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libpciaccess";
    license = with lib.licenses; [
      mit
      isc
      x11
    ];
    pkgConfigModules = [ "pciaccess" ];
    # https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/blob/6cd5a4afbb70868c7746de8d50dea59e02e9acf2/configure.ac#L108-114
    platforms =
      with lib.platforms;
      cygwin
      ++ freebsd
      ++ illumos
      ++ linux
      ++ lib.platforms.netbsd # otherwise netbsd from the function arguments is used
      ++ openbsd;
    badPlatforms = [
      # mandatory shared library
      lib.systems.inspect.platformPatterns.isStatic
    ];
  };
})
