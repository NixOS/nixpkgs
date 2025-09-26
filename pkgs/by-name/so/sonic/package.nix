{
  lib,
  stdenv,
  fetchFromGitHub,
  fftw,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "sonic-unstable";
  version = "2020-12-27";

  src = fetchFromGitHub {
    owner = "waywardgeek";
    repo = "sonic";
    rev = "4a052d9774387a9d9b4af627f6a74e1694419960";
    sha256 = "0ah54nizb6iwcx277w104wsfnx05vrp4sh56d2pfxhf8xghg54m6";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ fftw ];

  postInstall = ''
    installManPage sonic.1
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id $out/lib/libsonic.so.0.3.0 $out/lib/libsonic.so.0.3.0
  '';

  meta = with lib; {
    description = "Simple library to speed up or slow down speech";
    mainProgram = "sonic";
    homepage = "https://github.com/waywardgeek/sonic";
    license = licenses.asl20;
    maintainers = with maintainers; [ aske ];
    platforms = platforms.all;
  };
}
