{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, vulkan-loader
}:

rustPlatform.buildRustPackage {
  pname = "hayabusa";
  version = "unstable-2023-11-29";

  src = fetchFromGitHub {
    owner = "notarin";
    repo = "hayabusa";
    rev = "306167c632173f6633e51c5610fe32af7718ec25";
    hash = "sha256-e2zoVIhxcE9cUypi8Uzz3YZe2JvIaEVuWOGpqHVtxn8=";
  };

  cargoHash = "sha256-aoticMTrKZkRtjVXgdiBfyXJN3YcwBpM3yt07BBd3do=";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    vulkan-loader
  ];

  postPatch = ''
    substituteInPlace src/daemon/hayabusa.service \
      --replace "/usr/local" "$out"
  '';

  postInstall = ''
    install -Dm444 src/daemon/hayabusa.service -t $out/lib/systemd/system/
  '';

  meta = {
    description = "Swift rust fetch program";
    homepage = "https://github.com/notarin/hayabusa";
    license = lib.licenses.cc-by-nc-nd-40;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "hayabusa";
    platforms = lib.platforms.linux;
  };
}
