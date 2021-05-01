{ stdenv, lib, rustPlatform, fetchFromGitHub
, pkg-config, libevdev, openssl, llvmPackages, linuxHeaders
}:

rustPlatform.buildRustPackage rec {
  pname = "rkvm-unstable";
  version = "ec404c69";

  src = fetchFromGitHub {
    owner = "htrefil";
    repo = "rkvm";
    rev = "ec404c69b38f7feff5103f898612734ee8d7ee95";
    sha256 = "sha256-YZXHbZ71EsSyAtTenQ4rgp1fJbatkk7BW4Cmr/RpyXc=";
  };

  cargoSha256 = "sha256-/VNnqKSPqAYXS312GaTtpl5j0uOHLfUX8u7LuEDhUTg=";

  nativeBuildInputs = [ llvmPackages.clang pkg-config openssl ];
  buildInputs = [ libevdev openssl linuxHeaders ];

  BINDGEN_EXTRA_CLANG_ARGS = "-I${lib.getDev libevdev}/include/libevdev-1.0";
  LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  # The libevdev bindings preserve comments from libev, some of which
  # contain indentation which Cargo tries to interpret as doc tests.
  doCheck = false;

  meta = with lib; {
    description = "Virtual KVM switch for Linux machines";
    homepage = "https://github.com/htrefil/rkvm";
    license = licenses.mit;
    maintainers = [ maintainers.colemickens ];
  };
}
