{ stdenv, makeQtWrapper, fetchFromGitHub, fetchpatch
, cmake, pkgconfig, libxcb, libpthreadstubs, lndir
, libXdmcp, libXau, qtbase, qtdeclarative, qttools, pam, systemd
, themes
}:

let
  version = "0.13.0";

  unwrapped = stdenv.mkDerivation rec {
    name = "sddm-unwrapped-${version}";

    src = fetchFromGitHub {
      owner = "sddm";
      repo = "sddm";
      rev = "v${version}";
      sha256 = "0c3q8lpb123m9k5x3i71mm8lmyzhknw77zxh89yfl8qmn6zd61i1";
    };

    patches = [
      ./0001-ignore-config-mtime.patch
      ./0002-fix-ConfigReader-QStringList-corruption.patch
      (fetchpatch {
        url = https://github.com/benjarobin/sddm/commit/7d05362e3c7c5945ad85b0176771bc1c5a370598.patch;
        sha256 = "17f174lsb8vm7k1vx00yiqcipyyr6hgg4rm1rclps7saapfah5sj";
      })
    ];

    nativeBuildInputs = [ cmake pkgconfig qttools ];

    buildInputs = [
      libxcb libpthreadstubs libXdmcp libXau qtbase pam systemd
    ];

    propagatedBuildInputs = [ qtdeclarative ];

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
      export cmakeFlags="$cmakeFlags -DQT_IMPORTS_DIR=$out/lib/qt5/qml -DCMAKE_INSTALL_SYSCONFDIR=$out/etc -DSYSTEMD_SYSTEM_UNIT_DIR=$out/lib/systemd/system"
    '';

    enableParallelBuilding = true;

    postInstall = ''
      # remove empty scripts
      rm "$out/share/sddm/scripts/Xsetup" "$out/share/sddm/scripts/Xstop"
    '';

    meta = with stdenv.lib; {
      description = "QML based X11 display manager";
      homepage = https://github.com/sddm/sddm;
      platforms = platforms.linux;
      maintainers = with maintainers; [ abbradar ttuegel ];
    };
  };

in

stdenv.mkDerivation {
  name = "sddm-${version}";

  nativeBuildInputs = [ lndir makeQtWrapper ];
  buildInputs = [ unwrapped ] ++ themes;
  themes = map (pkg: pkg.out or pkg) themes;
  inherit unwrapped;

  unpackPhase = "true";
  configurePhase = "runHook preConfigure; runHook postConfigure";
  buildPhase = "runHook preBuild; runHook postBuild";

  installPhase = ''
    runHook preInstall

    makeQtWrapper "$unwrapped/bin/sddm" "$out/bin/sddm"

    mkdir -p "$out/share/sddm"
    for pkg in $unwrapped $themes; do
        local sddmDir="$pkg/share/sddm"
        if [ -d "$sddmDir" ]; then
            lndir -silent "$sddmDir" "$out/share/sddm"
        fi
    done

    runHook postInstall
  '';

  inherit (unwrapped) meta;
}
