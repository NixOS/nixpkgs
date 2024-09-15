{
  lib,
  stdenv,
  buildPackages,
  autoreconfHook,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "alsa-firmware";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://alsa/firmware/alsa-firmware-${version}.tar.bz2";
    hash = "sha256-tnttfQi8/CR+9v8KuIqZwYgwWjz1euLf0LzZpbNs1bs=";
  };

  patches = [
    # fixes some includes / missing types on musl libc; should not make a difference for other platforms
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/ae690000017d5fd355ab397c49202426e3a01c11/srcpkgs/alsa-firmware/patches/musl.patch";
      hash = "sha256-4A+TBBvpz14NwMNewLc2LQL51hnz4EZlZ44rhnx5dnc=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "--with-hotplug-dir=$(out)/lib/firmware" ];

  depsBuildBuild = lib.optional (
    stdenv.buildPlatform != stdenv.hostPlatform || stdenv.hostPlatform.isAarch64
  ) buildPackages.stdenv.cc;

  dontStrip = true;

  postInstall = ''
    # These are lifted from the Arch PKGBUILD
    # remove files which conflicts with linux-firmware
    rm -rf $out/lib/firmware/{ct{efx,speq}.bin,ess,korg,sb16,yamaha}
    # remove broken symlinks (broken upstream)
    rm -rf $out/lib/firmware/turtlebeach
    # remove empty dir
    rm -rf $out/bin
  '';

  meta = with lib; {
    homepage = "http://www.alsa-project.org/";
    description = "Soundcard firmwares from the alsa project";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ l-as ];
  };
}
