{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  wxGTK32,
  gtk3,
  zlib,
  libjpeg,
  libvncserver,
  cmake,
  pkg-config,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  xorg,
  lerc,
  libxkbcommon,
  libepoxy,
  wrapGAppsHook3,
}:

let
  # libvncserver does not support multicast. since multivnc is mostly about multicast, it requires a special branch of libvncserver.
  libvncserver-patched = libvncserver.overrideAttrs {
    src = fetchFromGitHub {
      owner = "LibVNC";
      repo = "libvncserver";
      rev = "ef3b57438564f2877148a23055f3f0ffce66df11";
      hash = "sha256-Cg96tsi6h1DX4VSsq1B8DTn0GxnBfoZK2nuxeT/+ca0=";
    };
    patches = [ ];
  };

in
stdenv.mkDerivation {
  pname = "MultiVNC";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "bk138";
    repo = "multivnc";
    rev = "89225243412f43ba2903ffeda98af7fe1f8f4975";
    hash = "sha256-qdF6nUSGaTphoe6T3gTAJTSQwvu+v/g8xfYobFBmGsI=";
    fetchSubmodules = true;
  };

  patches = [
    # remove part of vendored libraries that can be provided by Nixpkgs
    ./nixpkgs.patch

    # silences a compiler warning
    (fetchpatch {
      url = "https://github.com/bk138/multivnc/commit/002ba7f6b5b88dac3da5c08f99be1f237dcde904.patch";
      hash = "sha256-Qnk7RrUaw9jsaNTbzYqsH0LU8ivT9xX2jfxrES82ArE=";
    })
  ];

  # remove submodules we don't need
  # some submodules can be provided by nixpkgs
  postPatch = ''
    rm -rfv libvncserver libsshtunnel libjpeg-turbo libressl libssh2
  '';

  buildInputs = [
    gtk3
    wxGTK32
    zlib
    libjpeg
    libvncserver-patched

    # transitive dependencies
    libsysprof-capture
    pcre2
    util-linux # mount
    libselinux
    libsepol
    libthai
    libdatrie
    lerc
    libxkbcommon
    libepoxy
    xorg.libXdmcp
    xorg.libXtst
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  meta = {
    mainProgram = "multivnc";
    description = "Cross-platform Multicast-enabled VNC viewer based on LibVNCClient";
    homepage = "https://github.com/bk138/multivnc";
    maintainers = with lib.maintainers; [ rhelmot ];
    license = lib.licenses.gpl3Plus;
  };
}
