{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "knock";
  version = "0.0.2";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "nat-418";
    repo = "knock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Iqx/UBZlsO8qxXpiZ/m61ojvfepodwUoWaP2Q9uh648=";
  };

  # devendor go modules
  prePatch = ''
    rm -rf vendor/
  '';

  vendorHash = "sha256-wkSXdIgfkHbVJYsgm/hLAeKA9geof92U3mzSzt7eJE8=";

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage man/man1/knock.1
  '';

  meta = {
    description = "Simple CLI network reachability tester";
    homepage = "https://codeberg.org/nat-418/knock";
    license = lib.licenses.bsd0;
    changelog = "https://codeberg.org/nat-418/knock/raw/branch/trunk/CHANGELOG.md";
    maintainers = with lib.maintainers; [ nat-418 ];
  };
})
