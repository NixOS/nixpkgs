{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  bison,
  flex,
  which,
  perl,
  rrdtool,
  sensord ? false,
}:

let
  version = "3.6.2";
  tag = "V" + lib.replaceStrings [ "." ] [ "-" ] version;

in
stdenv.mkDerivation {
  pname = "lm-sensors";
  inherit version;

  src = fetchFromGitHub {
    owner = "hramrach"; # openSUSE fork used by openSUSE and Gentoo
    repo = "lm-sensors";
    inherit tag;
    hash = "sha256-EmS9H3TQac6bHs2G8t1C2cQNAjN13zPoKDysny6aTFw=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
    "doc"
  ];

  postPatch =
    # This allows sensors to continue reading the sensors3.conf as provided by
    # upstream and also look for config fragments in /etc/sensors.d
    ''
      substituteInPlace lib/init.c \
        --replace-fail 'ETCDIR "/sensors.d"' '"/etc/sensors.d"'
    '';

  nativeBuildInputs = [
    bison
    flex
    which
  ];

  # bash is required for correctly replacing the shebangs in all tools for cross-compilation.
  buildInputs = [
    bash
    perl
  ]
  ++ lib.optional sensord rrdtool;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BINDIR=${placeholder "bin"}/bin"
    "SBINDIR=${placeholder "bin"}/bin"
    "INCLUDEDIR=${placeholder "dev"}/include"
    "MANDIR=${placeholder "man"}/share/man"
    # This is a dependency of the library.
    "ETCDIR=${placeholder "out"}/etc"
    "BUILD_SHARED_LIB=${if stdenv.hostPlatform.isStatic then "0" else "1"}"
    "BUILD_STATIC_LIB=${if stdenv.hostPlatform.isStatic then "1" else "0"}"

    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ]
  ++ lib.optional sensord "PROG_EXTRA=sensord";

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $doc/share/doc/lm_sensors
    cp -r configs doc/* $doc/share/doc/lm_sensors
  '';

  meta = {
    homepage = "https://hwmon.wiki.kernel.org/lm_sensors";
    changelog = "https://raw.githubusercontent.com/hramrach/lm-sensors/${tag}/CHANGES";
    description = "Tools for reading hardware sensors - maintained fork";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      pmy
      oxalica
    ];
    platforms = lib.platforms.linux;
    mainProgram = "sensors";
  };
}
