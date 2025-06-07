{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, qt6, libvlc }:

let
  version = "0.4.2";
  libvlcppSrc = fetchFromGitHub {
    owner = "videolan";
    repo = "libvlcpp";
    rev = "master";
    #      sha256 = pkgs.lib.fakeSha256;
    sha256 = "sha256-nnS4DMz/2VciCrhOBGRb1+kDbxj+ZOnEtQmzs/TJ870=";
  };
  pname = "mfaomp";
in stdenv.mkDerivation {
  inherit version;
  inherit pname;

  src = fetchFromGitHub {
    owner = "Neurofibromin";
    repo = "mfaomp";
    rev = "v${version}";
    #    sha256 = pkgs.lib.fakeSha256;
    sha256 = "sha256-nh7prQzqPbRQUYzJUZ4cAILdn2ElRdEkiRXyJdrtf9A=";
  };

  nativeBuildInputs = [ cmake pkg-config qt6.qtbase.dev qt6.wrapQtAppsHook ];

  buildInputs =
    [ qt6.qtbase qt6.qtmultimedia qt6.qtwebengine qt6.qtsvg libvlc ];

  cmakeFlags = [
    "-DQT_QMAKE_EXECUTABLE=${qt6.qtbase}/bin/qmake"
    "-DUSE_PREDOWNLOADED_LIBVLCPP=ON"
  ];

  postPatch = ''
    mkdir -p third_party/libvlcpp
    cp -r ${libvlcppSrc}/* ${libvlcppSrc}/.??* third_party/libvlcpp/ 2>/dev/null || true
  '';
  installPhase = ''
    runHook preInstall
    cmake --install . --prefix=$out
    runHook postInstall
  '';

  #  already done by cmake:
  #  postInstall = ''
  #
  #     install -Dm644 LICENSE $out/share/doc/${pname}/LICENSE.txt #this doesn't work because pname is not a known ...
  #  '';

  meta = with lib; {
    description = "Multiple Files At Once Media Player";
    homepage = "https://github.com/Neurofibromin/mfaomp";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ neurofibromin ];
    #      platforms = [ "x86_64-linux" ];
    platforms = lib.platforms.linux;
    mainProgram = "mfaomp";
  };
}
