{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zip,
  gettext,
  perl,
  wxGTK32,
  libXext,
  libXi,
  libXt,
  libXtst,
  xercesc,
  qrencode,
  libuuid,
  libyubikey,
  yubikey-personalization,
  curl,
  openssl,
  file,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "pwsafe";
  version = "1.23.0"; # do NOT update to 3.x Windows releases

  src = fetchFromGitHub {
    owner = "pwsafe";
    repo = "pwsafe";
    rev = version;
    hash = "sha256-54cwQZi93p32JxxLc2Mql2XbJPvwqA2Rfne5G+5i6eU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    perl
    pkg-config
    wxGTK32
    zip
  ];

  buildInputs = [
    wxGTK32
    curl
    qrencode
    openssl
    xercesc
    file
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libXext
    libXi
    libXt
    libXtst
    libuuid
    libyubikey
    yubikey-personalization
  ];

  cmakeFlags = [
    "-DNO_GTEST=ON"
    "-DCMAKE_CXX_FLAGS=-I${yubikey-personalization}/include/ykpers-1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DNO_YUBI=ON"
  ];

  postPatch = ''
    # Fix perl scripts used during the build.
    for f in $(find . -type f -name '*.pl') ; do
      patchShebangs $f
    done

    # Fix hard coded paths.
    for f in $(grep -Rl /usr/share/ src install/desktop) ; do
      substituteInPlace $f --replace /usr/share/ $out/share/
    done

    # Fix hard coded zip path.
    substituteInPlace help/Makefile.linux --replace /usr/bin/zip ${zip}/bin/zip

    for f in $(grep -Rl /usr/bin/ .) ; do
      substituteInPlace $f --replace /usr/bin/ ""
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/ui/cli/CMakeLists.txt --replace "uuid" ""
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.updateScript = gitUpdater {
    allowedVersions = "^1\\.";
    url = src.gitRepoUrl;
  };

  meta = with lib; {
    description = "Password database utility";
    longDescription = ''
      Password Safe is a password database utility. Like many other
      such products, commercial and otherwise, it stores your
      passwords in an encrypted file, allowing you to remember only
      one password (the "safe combination"), instead of all the
      username/password combinations that you use.
    '';
    homepage = "https://pwsafe.org/";
    maintainers = with maintainers; [
      c0bw3b
      pjones
    ];
    platforms = platforms.unix;
    license = licenses.artistic2;
  };
}
