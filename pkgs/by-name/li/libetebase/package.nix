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
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "libetebase";
    rev = "v${version}";
    hash = "sha256-sqvfzXHqVeiw+VKWPtCYv0USNpbfBE7ILUiqXZtLmgI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-z3ho6hTWC6aaWTpG9huhymx2og6xQq+/r+kgiJygC9w=";

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
