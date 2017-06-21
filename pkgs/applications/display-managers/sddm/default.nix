{ mkDerivation, lib, copyPathsToStore, fetchFromGitHub, fetchpatch
, cmake, extra-cmake-modules, pkgconfig, libxcb, libpthreadstubs, lndir
, libXdmcp, libXau, qtbase, qtdeclarative, qttools, pam, systemd
}:

let

  version = "0.14.0";

  /* Fix display of user avatars. */
  patchFixUserAvatars = fetchpatch {
    url = https://github.com/sddm/sddm/commit/ecb903e48822bd90650bdd64fe80754e3e9664cb.patch;
    sha256 = "0zm88944pwdad8grmv0xwnxl23xml85ryc71x2xac233jxdyx6ms";
  };

in mkDerivation rec {
  name = "sddm-unwrapped-${version}";

  src = fetchFromGitHub {
    owner = "sddm";
    repo = "sddm";
    rev = "v${version}";
    sha256 = "0wwid23kw0725zpw67zchalg9mmharr7sn4yzhijq7wqpsczjfxj";
  };

  patches =
    copyPathsToStore (lib.readPathsFromFile ./. ./series)
    ++ [ patchFixUserAvatars ];

  postPatch =
    # Module Qt5::Test must be included in `find_package` before it is used.
    ''
      sed -i CMakeLists.txt -e '/find_package(Qt5/ s|)| Test)|'
    '';

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig qttools ];

  buildInputs = [
    libxcb libpthreadstubs libXdmcp libXau pam systemd
  ];

  propagatedBuildInputs = [
    qtbase qtdeclarative
  ];

  cmakeFlags = [
    "-DCONFIG_FILE=/etc/sddm.conf"
    # Set UID_MIN and UID_MAX so that the build script won't try
    # to read them from /etc/login.defs (fails in chroot).
    # The values come from NixOS; they may not be appropriate
    # for running SDDM outside NixOS, but that configuration is
    # not supported anyway.
    "-DUID_MIN=1000"
    "-DUID_MAX=29999"
  ];

  preConfigure = ''
    export cmakeFlags="$cmakeFlags -DQT_IMPORTS_DIR=$out/$qtQmlPrefix -DCMAKE_INSTALL_SYSCONFDIR=$out/etc -DSYSTEMD_SYSTEM_UNIT_DIR=$out/lib/systemd/system"
  '';

  postInstall = ''
    # remove empty scripts
    rm "$out/share/sddm/scripts/Xsetup" "$out/share/sddm/scripts/Xstop"
  '';

  meta = with lib; {
    description = "QML based X11 display manager";
    homepage = "https://github.com/sddm/sddm";
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ttuegel ];
  };
}
