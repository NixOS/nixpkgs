{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
  libsecret,
  olm,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quaternion";
  version = "0.0.97.1";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "Quaternion";
    tag = finalAttrs.version;
    hash = "sha256-Dn4E3mTqcNK88PNraL+qR1gREob5j7s3Qf8XAaTNSJg=";
  };

  buildInputs = [
    kdePackages.libquotient
    libsecret
    olm
    qt6.qtbase
    kdePackages.qtkeychain
    qt6.qtmultimedia
  ];

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  env.LANG = "C.UTF-8";

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        mv $out/bin/quaternion.app $out/Applications
        rmdir $out/bin || :
      ''
    else
      ''
        substituteInPlace $out/share/applications/io.github.quotient_im.Quaternion.desktop \
          --replace-fail 'Exec=quaternion' "Exec=$out/bin/quaternion"
      '';

  meta = {
    description = "Cross-platform desktop IM client for the Matrix protocol";
    mainProgram = "quaternion";
    homepage = "https://matrix.org/ecosystem/clients/quaternion/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
})
