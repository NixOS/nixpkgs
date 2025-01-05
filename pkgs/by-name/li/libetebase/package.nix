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
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "libetebase";
    rev = "v${version}";
    hash = "sha256-cXuOKfyMdk+YzDi0G8i44dyBRf4Ez5+AlCKG43BTSSU=";
  };

  cargoHash = "sha256-GUNj5GrY04CXnej3WDKZmW4EeJhoCl2blHSDfEkQKtE=";

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
    description = "A C library for Etebase";
    homepage = "https://www.etebase.com/";
    license = licenses.bsd3;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ laalsaas ];
    pkgConfigModules = [ "etebase" ];
  };
}
