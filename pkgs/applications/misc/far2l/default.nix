{ lib, stdenv, fetchFromGitHub, makeWrapper, cmake, ninja, pkg-config, m4, bash
, xdg-utils, zip, unzip, gzip, bzip2, gnutar, p7zip, xz
, IOKit, Carbon, Cocoa, AudioToolbox, OpenGL, System
, withTTYX ? true, libX11
, withGUI ? true, wxGTK32
, withUCD ? true, libuchardet

# Plugins
, withColorer ? true, spdlog, xercesc
, withMultiArc ? true, libarchive, pcre
, withNetRocks ? true, openssl, libssh, samba, libnfs, neon
, withPython ? false, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "far2l";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = "v_${version}";
    sha256 = "sha256-0t1ND6LmDcivfrZ8RaEr1vjeS5JtaeWkoHkl2e7Xr5s=";
  };

  patches = [ ./python_prebuild.patch ];

  nativeBuildInputs = [ cmake ninja pkg-config m4 makeWrapper ];

  buildInputs = lib.optional withTTYX libX11
    ++ lib.optional withGUI wxGTK32
    ++ lib.optional withUCD libuchardet
    ++ lib.optionals withColorer [ spdlog xercesc ]
    ++ lib.optionals withMultiArc [ libarchive pcre ]
    ++ lib.optionals withNetRocks [ openssl libssh libnfs neon ]
    ++ lib.optional (withNetRocks && !stdenv.isDarwin) samba # broken on darwin
    ++ lib.optionals withPython (with python3Packages; [ python cffi debugpy pcpp ])
    ++ lib.optionals stdenv.isDarwin [ IOKit Carbon Cocoa AudioToolbox OpenGL System ];

  postPatch = ''
    patchShebangs python/src/prebuild.sh
    substituteInPlace far2l/src/vt/vtcompletor.cpp \
      --replace '"/bin/bash"' '"${bash}/bin/bash"'
    substituteInPlace far2l/src/cfg/config.cpp \
      --replace '"/bin/bash"' '"${bash}/bin/bash"'
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

  runtimeDeps = [ unzip zip p7zip xz gzip bzip2 gnutar ];

  postInstall = ''
    wrapProgram $out/bin/far2l \
      --argv0 $out/bin/far2l \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = with lib; {
    description = "Linux port of FAR Manager v2, a program for managing files and archives in Windows operating systems";
    homepage = "https://github.com/elfmz/far2l";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ hypersw ];
    platforms = platforms.unix;
  };
}
