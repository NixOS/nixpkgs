{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  vulkan-loader,
}:

rustPlatform.buildRustPackage {
  pname = "hayabusa";
  version = "unstable-2023-11-29";

  src = fetchFromGitHub {
    owner = "notarin";
    repo = "hayabusa";
    rev = "1d6b8cfd301d60ff9f6946970b51818c036083b0";
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
    license = lib.licenses.cc-by-nc-nd-40;
    maintainers = with lib.maintainers; [ Notarin ];
    mainProgram = "hayabusa";
    platforms = lib.platforms.linux;
  };
}
