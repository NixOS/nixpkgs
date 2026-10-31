{
  lib,
  rustPlatform,
  makeBinaryWrapper,
  installShellFiles,
  fuse,
  openssl,
  pkg-config,
  fetchFromCodeberg,
  nix-update-script,
  tlsSupport ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fuseftp";
  version = "0.1.0";

  src = fetchFromCodeberg {
    owner = "nettika";
    repo = "fuseftp";
    tag = finalAttrs.version;
    hash = "sha256-e2OgiB+g4d8c3mlTi9xVQgyYw62RGfR725C2QYxVgs8=";
  };

  cargoHash = "sha256-fByvf6ypfkWDTZoXxCF8ovsDN9CggNTblV3rYq4dKu4=";

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optional tlsSupport "tls";

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ]
  ++ lib.optional tlsSupport pkg-config;

  buildInputs = lib.optional tlsSupport openssl;

  postInstall = ''
    wrapProgram $out/bin/mount_fuse_ftp --prefix PATH : $out/bin
    ln -s $out/bin/mount_fuse_ftp $out/bin/mount.fuse.ftp
    installManPage man/fuseftp.1 man/mount.fuse.ftp.8
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit (fuse.meta) platforms;
    description = "Mount FTP servers as local filesystems";
    homepage = "https://codeberg.org/nettika/fuseftp";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ nettika ];
    mainProgram = "fuseftp";
  };
})
