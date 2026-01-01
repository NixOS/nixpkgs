{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  dbus,
  fmt_9,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "simpleDBus";

<<<<<<< HEAD
  version = "0.10.4";
=======
  version = "0.10.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "OpenBluetoothToolbox";
    repo = "SimpleBLE";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-KNSrw+NhfHRuvDwkWpWTSnP6LWoSVWAa33fVikb60A8=";
=======
    hash = "sha256-eEbptFy5tlIHuBu+HbPxsgdb9CVNXq8r2KKP0E8SIuE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  outputs = [
    "out"
    "dev"
  ];

  sourceRoot = "${finalAttrs.src.name}/simpledbus";

  cmakeFlags = [ "-DLIBFMT_LOCAL_PATH=${fmt_9.src}" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

<<<<<<< HEAD
  meta = {
    description = "C++ wrapper for libdbus-1";
    homepage = "https://github.com/OpenBluetoothToolbox/SimpleBLE";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ aciceri ];
=======
  meta = with lib; {
    description = "C++ wrapper for libdbus-1";
    homepage = "https://github.com/OpenBluetoothToolbox/SimpleBLE";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ aciceri ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
