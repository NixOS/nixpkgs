{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  wrapQtAppsHook,
  qtbase,
  qtquickcontrols2 ? null, # only a separate package on qt5
  qtkeychain,
  qtmultimedia,
  qttools,
  libquotient,
  libsecret,
  olm,
}:

let
  inherit (lib) cmakeBool;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "quaternion";
  version = "0.0.96.1";

  src = fetchFromGitHub {
    owner = "quotient-im";
    repo = "Quaternion";
    rev = finalAttrs.version;
    hash = "sha256-lRCSEb/ldVnEv6z0moU4P5rf0ssKb9Bw+4QEssLjuwI=";
  };

  buildInputs = [
    libquotient
    libsecret
    olm
    qtbase
    qtkeychain
    qtmultimedia
    qtquickcontrols2
  ];

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  # qt6 needs UTF
  env.LANG = "C.UTF-8";

  cmakeFlags = [
    # drop this from 0.0.97 onwards as it will be qt6 only
    (cmakeBool "BUILD_WITH_QT6" ((lib.versions.major qtbase.version) == "6"))
  ];

  postInstall =
    if stdenv.isDarwin then
      ''
        mkdir -p $out/Applications
        mv $out/bin/quaternion.app $out/Applications
        rmdir $out/bin || :
      ''
    else
      ''
        substituteInPlace $out/share/applications/com.github.quaternion.desktop \
          --replace 'Exec=quaternion' "Exec=$out/bin/quaternion"
      '';

  meta = with lib; {
    description = "Cross-platform desktop IM client for the Matrix protocol";
    mainProgram = "quaternion";
    homepage = "https://matrix.org/ecosystem/clients/quaternion/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (qtbase.meta) platforms;
  };
})
