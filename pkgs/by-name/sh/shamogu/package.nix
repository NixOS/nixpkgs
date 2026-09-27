{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "shamogu";
  version = "1.5.0";

  src = fetchFromCodeberg {
    owner = "anaseto";
    repo = "shamogu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d4PtFOVr176JqybKrKXpqNs3j8cDY9ixTkmAh0UV/TQ=";
  };

  vendorHash = "sha256-wibNLDdykV2psOnJbMKu0EZSrrhKRxrN/OTWXmUz2FM=";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installManPage docs/shamogu.6
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Roguelike game focused on tactical movement and careful timing";
    homepage = "https://anaseto.codeberg.page/games/shamogu/";
    mainProgram = "shamogu";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
