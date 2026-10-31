{
  lib,
  stdenv,
  fetchFromGitHub,
  mbedtls,
  meson,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "ps3netsrv";
  version = "20260913";

  src = fetchFromGitHub {
    owner = "aldostools";
    repo = pname;
    tag = version;
    hash = "sha256-Lsazt178L6oP9AzpKs4MP6aMRFq7HydJ/uVZMYbOWGE=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # ps3netsrv will crash with a buffer overflow error,
  # when trying loading a game without this.
  hardeningDisable = [ "fortify" ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    mbedtls
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Doff64_t=off_t";

  postInstall = ''
    install -Dm644 $src/LICENSE.TXT $out/usr/share/licenses/${pname}/LICENSE.TXT
  '';

  meta = {
    description = "PS3 Net Server (mod by aldostools)";
    homepage = "https://github.com/aldostools/ps3netsrv/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ makefu ];
    mainProgram = "ps3netsrv";
  };
}
