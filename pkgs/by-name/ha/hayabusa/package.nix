{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  vulkan-loader,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hayabusa";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "notarin";
    repo = "hayabusa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GSyauhVDWsiTOKdH09pz9y3pkiMzvtDNqd+izXtHQG8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ioql3gKKOZB9J/97m5IsCtpxAyqH3eXHH6Cnrb9962g=";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    vulkan-loader
  ];

  postPatch = ''
    substituteInPlace distribution/hayabusa.service \
      --replace-fail "/usr/local" "$out"
  '';

  postInstall = ''
    install -Dm444 distribution/hayabusa.service -t $out/lib/systemd/system/
  '';

  meta = {
    description = "Swift rust fetch program";
    homepage = "https://github.com/notarin/hayabusa";
    license = lib.licenses.cc-by-nc-nd-40;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "hayabusa";
    platforms = lib.platforms.linux;
  };
})
