{
  lib,
  stdenv,
  fetchzip,
  pugixml,
  updfparser,
  curl,
  openssl,
  libzip,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "libgourou";
  version = "0.8.2";

  src = fetchzip {
    sha256 = "sha256-adkrvBCgN07Ir+J3JFCy+X9p9609lj1w8nElrlHXTxc";
    url = "https://forge.soutade.fr/soutade/libgourou/archive/v${version}.tar.gz";
  };

  postPatch = ''
    patchShebangs scripts/setup.sh
  '';

  postConfigure = ''
    mkdir lib
    ln -s ${updfparser}/lib lib/updfparser
  '';

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [
    pugixml
    updfparser
    curl
    openssl
    libzip
  ];

  makeFlags = [
    "BUILD_STATIC=1"
    "BUILD_SHARED=1"
  ];

  installPhase = ''
    runHook preInstall
    install -Dt $out/include include/libgourou*.h
    install -Dt $out/lib libgourou.so
    install -Dt $out/lib libgourou.so.${version}
    install -Dt $out/lib libgourou.a
    install -Dt $out/bin utils/acsmdownloader
    install -Dt $out/bin utils/adept_{activate,loan_mgt,remove}
    installManPage utils/man/*.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Implementation of Adobe's ADEPT protocol for ePub/PDF DRM";
    homepage = "https://indefero.soutade.fr/p/libgourou";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ autumnal ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
