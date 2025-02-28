{
  lib,
  fetchurl,
  stdenv,
  slang,
  popt,
  python3,
  gettext,
}:

let
  pythonIncludePath = "${lib.getDev python3}/include/python";
in
stdenv.mkDerivation rec {
  pname = "newt";
  version = "0.52.24";

  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-Xe1+Ih+F9kJSHEmxgmyN4ZhFqjcrr11jClF3S1RPvbs=";
  };

  postPatch = ''
    sed -i -e s,/usr/bin/install,install, -e s,-I/usr/include/slang,, Makefile.in po/Makefile

    substituteInPlace configure \
      --replace "/usr/include/python" "${pythonIncludePath}"
    substituteInPlace configure.ac \
      --replace "/usr/include/python" "${pythonIncludePath}"

    substituteInPlace Makefile.in \
      --replace "ar rv" "${stdenv.cc.targetPrefix}ar rv"
  '';

  strictDeps = true;
  nativeBuildInputs = [ python3 ];
  buildInputs =
    [
      slang
      popt
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      gettext # for darwin with clang
    ];

  NIX_LDFLAGS =
    "-lncurses"
    + lib.optionalString stdenv.hostPlatform.isDarwin " -L${python3}/lib -lpython${python3.pythonVersion}";

  preConfigure = ''
    # If CPP is set explicitly, configure and make will not agree about which
    # programs to use at different stages.
    unset CPP
  '';

  makeFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id $out/lib/libnewt.so.${version} $out/lib/libnewt.so.${version}
    install_name_tool -change libnewt.so.${version} $out/lib/libnewt.so.${version} $out/bin/whiptail
  '';

  meta = {
    description = "Library for color text mode, widget based user interfaces";
    mainProgram = "whiptail";
    homepage = "https://pagure.io/newt";
    changelog = "https://pagure.io/newt/blob/master/f/CHANGES";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bryango ];
  };
}
