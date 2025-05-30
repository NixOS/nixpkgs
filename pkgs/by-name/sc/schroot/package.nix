{
  lib,
  stdenv,
  fetchurl,

  # Runtime script dependencies
  coreutils,
  getent,
  gnugrep,
  gnused,
  gnutar,
  util-linux,

  # Native build inputs
  cmake,
  findutils,
  gettext,
  mandoc,
  makeWrapper,
  perlPackages,

  # Build inputs
  boost,
}:

let
  scripts-bin-path = lib.makeBinPath [
    coreutils
    getent
    gnugrep
    gnused
    gnutar
    util-linux
  ];
  upstream-version = "1.6.13";
in
stdenv.mkDerivation {
  pname = "schroot";
  version = "${upstream-version}-5";

  src = fetchurl {
    url = "https://codeberg.org/shelter/reschroot/archive/release/reschroot-${upstream-version}.tar.gz";
    hash = "sha256-wF1qG7AhDUAeZSLu4sRl4LQ8bJj3EB1nH56e+Is6zPU=";
  };

  patches = map fetchurl (import ./debian-patches.nix) ++ [
    ./no-setuid.patch
    ./no-pam-service.patch
    ./no-default-config.patch
    ./fix-absolute-paths.patch
    ./fix-boost-includes.patch
  ];

  nativeBuildInputs = [
    cmake
    findutils
    gettext
    mandoc
    makeWrapper
    perlPackages.Po4a
  ];

  buildInputs = [
    boost
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_LOCALSTATEDIR" "/var")
    (lib.cmakeFeature "SCHROOT_SYSCONF_DIR" "/etc/schroot")
    (lib.cmakeFeature "SCHROOT_CONF_SETUP_D" "${placeholder "out"}/etc/schroot/setup.d")
  ];

  postPatch = ''
    # Substitute the path to the mount binary
    substituteInPlace bin/schroot-mount/schroot-mount-main.cc \
      --replace-fail "/bin/mount" "${util-linux}/bin/mount"
  '';

  postFixup = ''
    # Make wrappers for all shell scripts used by schroot
    # The wrapped script are put into a separate directory to not be run by schroot during setup
    mkdir $out/etc/schroot/setup.d.wrapped
    cd $out/etc/schroot/setup.d
    find * -type f | while read -r file; do
      mv "$file" $out/etc/schroot/setup.d.wrapped
      makeWrapper "$out/etc/schroot/setup.d.wrapped/$file" "$file" --set PATH ${scripts-bin-path}
    done

    # Get rid of stuff that's (probably) not needed
    rm -vrf $out/lib $out/include
  '';

  meta = {
    description = "Lightweight virtualisation tool";
    longDescription = ''
      Schroot is a program that allows the user to run a command or a login shell in a chroot environment.
    '';
    homepage = "https://codeberg.org/shelter/reschroot";
    changelog = "https://codeberg.org/shelter/reschroot/raw/tag/release/reschroot-${upstream-version}/NEWS";
    mainProgram = "schroot";
    maintainers = with lib.maintainers; [ bjsowa ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
