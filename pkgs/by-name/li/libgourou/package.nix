{
  lib,
  stdenv,
  fetchFromGitea,
  pugixml,
  updfparser,
  curl,
  openssl,
  libzip,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgourou";
  version = "0.8.7";

  src = fetchFromGitea {
    domain = "forge.soutade.fr";
    owner = "soutade";
    repo = "libgourou";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tkft/pe3lH07pmyVibTEutIIvconUWDH1ZVN3qV4sSY=";
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
    install -Dt $out/lib libgourou.so.${finalAttrs.version}
    install -Dt $out/lib libgourou.a
    install -Dt $out/bin utils/acsmdownloader
    install -Dt $out/bin utils/adept_{activate,loan_mgt,remove}
    installManPage utils/man/*.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Implementation of Adobe's ADEPT protocol for ePub/PDF DRM";
    homepage = "https://forge.soutade.fr/soutade/libgourou";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ autumnal ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
