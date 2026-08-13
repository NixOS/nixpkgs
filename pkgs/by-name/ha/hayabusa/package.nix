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
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "notarin";
    repo = "hayabusa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w9vXC7L7IP4QLPFS1IgPOKSm7fT7W0R+NsHTdAfIupg=";
  };

  cargoHash = "sha256-F1dUv1SR6cf1o6a2JG2i2fCgjZpGsG20mskIrf3oiHY=";

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
      --replace "/usr/local" "$out"
  '';

  postInstall = ''
    install -Dm444 distribution/hayabusa.service -t $out/lib/systemd/system/
  '';

  meta = {
    description = "Swift rust fetch program";
    homepage = "https://github.com/notarin/hayabusa";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Notarin ];
    mainProgram = "hayabusa";
    platforms = lib.platforms.linux;
  };
})
