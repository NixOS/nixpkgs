{ lib, stdenv, fetchFromGitHub, coreutils, cmake, ninja, qt6, boost, openssl, gpgme, libconfig, libarchive }:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpgfrontend";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "saturneric";
    repo = "gpgfrontend";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9iqywMGXV6PDPdQsUnjkZ7kEYG/6SRw3pXdo+iOkZUo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ninja qt6.wrapQtAppsHook coreutils ];
  buildInputs =
    [ boost openssl qt6.qtbase qt6.qt5compat gpgme libconfig libarchive ];

  cmakeFlags = [
    "--no-warn-unused-cli"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  postConfigure = ''
    substituteInPlace ../src/CMakeLists.txt \
      --replace "/bin/mkdir" "${coreutils}/bin/mkdir"
    substituteInPlace ../src/CMakeLists.txt \
      --replace "/bin/mv" "${coreutils}/bin/mv"
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp src/ui/libgpgfrontend_ui.so $out/lib/
    cp src/core/libgpgfrontend_core.so $out/lib/

    cp -r release/gpgfrontend/var/empty/bin $out/
    cp -r release/gpgfrontend/var/empty/share $out/
    cp -r release/gpgfrontend/usr/share $out/
  '';

  meta = with lib; {
    description = "GUI frontend for GnuPG";
    longDescription = ''
    GpgFrontend is a free, open-source, robust yet user-friendly, compact and cross-platform tool for OpenPGP encryption. It stands out as an exceptional GUI frontend for the modern GnuPG (gpg).

    When using GpgFrontend, you can:

    - Rapidly encrypt files or text.
    - Digitally sign your files or text with ease.
    - Conveniently manage all your GPG keys on your device.
    - Transfer all your GPG keys between devices safely and effortlessly.
    '';
    homepage = "https://github.com/saturneric/GpgFrontend";
    license = licenses.gpl3;
    maintainers = [ maintainers.whimbree ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
  };
})
