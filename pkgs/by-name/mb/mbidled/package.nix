{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  libev,
  openssl,
}:

stdenv.mkDerivation {
  pname = "mbidled";
  version = "0-unstable-2023-09-30";

  src = fetchFromGitHub {
    owner = "zsugabubus";
    repo = "mbidled";
    rev = "c724a34cc01b829b19a60655fc1652a378db7f27";
    sha256 = "sha256-XQXLPjEEesBd+bATsKE2nvoNcuqtRA1JIsV7306CssA=";
  };

  preConfigure = ''
    export LIBRARY_PATH=${libev}/lib
  '';

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    libev
    openssl
  ];

<<<<<<< HEAD
  meta = {
    description = "Run command on mailbox change";
    homepage = "https://github.com/zsugabubus/mbidled";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ laalsaas ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Run command on mailbox change";
    homepage = "https://github.com/zsugabubus/mbidled";
    license = licenses.unlicense;
    maintainers = with maintainers; [ laalsaas ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mbidled";
  };
}
