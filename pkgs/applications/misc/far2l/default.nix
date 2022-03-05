{ lib, stdenv, fetchFromGitHub, makeWrapper, cmake, ninja, pkg-config, m4, bash
, xdg-utils, zip, unzip, gzip, bzip2, gnutar, p7zip, xz
, IOKit, Carbon, Cocoa, AudioToolbox, OpenGL
, withTTYX ? true, libX11
, withGUI ? true, wxGTK30, wxmac
, withUCD ? true, libuchardet

# Plugins
, withColorer ? true, spdlog, xercesc
, withMultiArc ? true, libarchive, pcre
, withNetRocks ? true, openssl, libssh, samba, libnfs, neon
, withPython ? false, python3Packages
}:

let
  wxWidgets = (if stdenv.isDarwin then wxmac else wxGTK30);
in
stdenv.mkDerivation rec {
  pname = "far2l";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = "v_${version}";
    sha256 = "sha256-nfoAElPLQ97lj65MBX4JMEdgTFbkdEbR1BazYZgV/lg=";
  };

  patches = [ ./python_prebuild.patch ];

  nativeBuildInputs = [ cmake ninja pkg-config m4 makeWrapper ];

  buildInputs = lib.optional withTTYX libX11
    ++ lib.optional withGUI wxWidgets
    ++ lib.optional withUCD libuchardet
    ++ lib.optionals withColorer [ spdlog xercesc ]
    ++ lib.optionals withMultiArc [ libarchive pcre ]
    ++ lib.optionals withNetRocks [ openssl libssh libnfs neon ]
    ++ lib.optional (withNetRocks && !stdenv.isDarwin) samba # broken on darwin
    ++ lib.optionals withPython (with python3Packages; [ python cffi debugpy pcpp ])
    ++ lib.optionals stdenv.isDarwin [ IOKit Carbon Cocoa AudioToolbox OpenGL ];

  postPatch = ''
    patchShebangs python/src/prebuild.sh
    substituteInPlace far2l/src/vt/vtcompletor.cpp \
      --replace '"/bin/bash"' '"${bash}/bin/bash"'
    substituteInPlace far2l/src/cfg/config.cpp \
      --replace '"/bin/bash"' '"${bash}/bin/bash"'
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace WinPort/src/Backend/WX/CMakeLists.txt \
      --replace "-framework System" -lSystem
  '';

  cmakeFlags = lib.mapAttrsToList (k: v: "-D${k}=${if v then "yes" else "no"}") {
    TTYX = withTTYX;
    USEWX = withGUI;
    USEUCD = withUCD;
    COLORER = withColorer;
    MULTIARC = withMultiArc;
    NETROCKS = withNetRocks;
    PYTHON = withPython;
  };

  runtimeDeps = [ unzip zip p7zip xz gzip bzip2 gnutar xdg-utils ];

  postInstall = ''
    wrapProgram $out/bin/far2l \
      --argv0 $out/bin/far2l \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  meta = with lib; {
    description = "Linux port of FAR Manager v2, a program for managing files and archives in Windows operating systems";
    homepage = "https://github.com/elfmz/far2l";
    license = licenses.gpl2Plus; # NOTE: might change in far2l repo soon, check next time
    maintainers = with maintainers; [ volth hypersw ];
    platforms = platforms.unix;
  };
}
