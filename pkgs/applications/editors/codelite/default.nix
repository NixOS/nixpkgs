{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, which
, wrapGAppsHook
, harfbuzz
, hunspell
, libssh
, libuchardet
, openssh
, pcre2
, python3
, sqlite
, wxGTK
, zlib
}:
let
  runtimeDeps = [
    # for codelite-remote plugin
    openssh
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "codelite";
  version = "17.3.0";

  src = fetchFromGitHub {
    owner = "eranif";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "1SX5NT3/ngnK6WeZmNiP/RbPG5qbI88qjm0gBZyA6wg=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix GTK version detection that doesn't account for platform prefix when cross-compiling
    ./gtk-version-detection.patch
    # Don't build ctags as static library, needs static libc
    ./ctags-disable-static.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "/usr/include/harfbuzz" "${lib.getDev harfbuzz}/include/harfbuzz"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    which # needed to detect wx-config
    wrapGAppsHook
    wxGTK # wx-config
  ];

  buildInputs = [
    harfbuzz
    hunspell
    libssh
    libuchardet
    pcre2
    python3 # needed for codelite_open_helper.py
    sqlite
    wxGTK
    zlib
  ];

  hardeningDisable = [ "format" "fortify" ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Runtime dependencies
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"
    )
  '';

  meta = with lib; {
    description = "Multi purpose IDE specialized in C/C++/Rust/Python/PHP and Node.js";
    homepage = "https://codelite.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.linux;
  };
})
