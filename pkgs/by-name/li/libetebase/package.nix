{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  lib,
  stdenv,
  testers,
  libetebase,
}:
rustPlatform.buildRustPackage rec {
  pname = "libetebase";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "libetebase";
    rev = "v${version}";
    hash = "sha256-B+MfnYbxIbgMHFWWOYhap1MEbV3/NNYuR9goJDTNn9A=";
  };

  cargoHash = "sha256-ZLQFERi38+0SUxWaYAL4AepgVuAQKo9pxjcMkzA55BM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  postInstall = ''
    install -d $out/lib/pkgconfig
    sed s#@prefix@#$out#g etebase.pc.in > $out/lib/pkgconfig/etebase.pc
    install -Dm644 EtebaseConfig.cmake -t $out/lib/cmake/Etebase
    install -Dm644 target/etebase.h -t $out/include/etebase
    ln -s $out/lib/libetebase.so $out/lib/libetebase.so.0
  '';

  passthru.tests.pkgs-config = testers.testMetaPkgConfig libetebase;

  meta = with lib; {
    description = "C library for Etebase";
    homepage = "https://www.etebase.com/";
    license = licenses.bsd3;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ laalsaas ];
    pkgConfigModules = [ "etebase" ];
  };
}
