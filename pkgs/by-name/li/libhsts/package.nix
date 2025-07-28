{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchurl,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  python3,
}:
let
  chromium_version = "140.0.7324.1";

  hsts_list = fetchurl {
    url = "https://raw.github.com/chromium/chromium/${chromium_version}/net/http/transport_security_state_static.json";
    hash = "sha256-XV3yZA3Ai4It7S/y4V0h+UtKm8SXm6x1hlITD7jGY9I=";
  };

in
stdenv.mkDerivation rec {
  pname = "libhsts";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "rockdaboot";
    repo = "libhsts";
    rev = "libhsts-${version}";
    sha256 = "0gbchzf0f4xzb6zjc56dk74hqrmdgyirmgxvvsqp9vqn9wb5kkx4";
  };

  postPatch = ''
    pushd tests
    cp ${hsts_list} transport_security_state_static.json
    sed 's/^ *\/\/.*$//g' transport_security_state_static.json >hsts.json
    popd
    patchShebangs src/hsts-make-dafsa
  '';

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    python3
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "Library to easily check a domain against the Chromium HSTS Preload list";
    mainProgram = "hsts";
    homepage = "https://gitlab.com/rockdaboot/libhsts";
    license = with licenses; [
      mit
      bsd3
    ];
    maintainers = [ ];
  };
}
