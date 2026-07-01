{
  lib,
  stdenv,
  fetchFromGitLab,
  chromium-hsts-preload-list,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "libhsts";
  version = "0.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    owner = "rockdaboot";
    repo = "libhsts";
    tag = "libhsts-${version}";
    hash = "sha256-pM9ZFk8W73Sx3ru/mqN/rWYMyZnNFCa/Wb8TB9yHbD0=";
  };

  patches = [
    ./gettext-0.25.patch
  ];

  postPatch = ''
    pushd tests
    cp ${chromium-hsts-preload-list}/share/chromium-hsts-preload-list/transport_security_state_static.json .
    # strip comments from json
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

  meta = {
    description = "Library to easily check a domain against the Chromium HSTS Preload list";
    mainProgram = "hsts";
    homepage = "https://gitlab.com/rockdaboot/libhsts";
    license = with lib.licenses; [
      mit
      bsd3
    ];
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
