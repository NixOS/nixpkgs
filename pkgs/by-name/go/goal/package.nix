{
  buildGoModule,
  fetchFromCodeberg,
  installShellFiles,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "goal";
  version = "1.5.0";
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "anaseto";
    repo = "goal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9nDp2Ey20EBNO5bvrTWjCJMYw80rTQY6cmYLB0WTc7I=";
  };

  vendorHash = null;
  subPackages = [ "cmd/goal" ];
  tags = [ "full" ];

  postInstall = ''
    installManPage docs/goal.1
  '';
  nativeBuildInputs = [ installShellFiles ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Embeddable array programming language";
    homepage = "https://codeberg.org/anaseto/goal";
    changelog = "https://codeberg.org/anaseto/goal/src/branch/master/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.slotThe ];
    mainProgram = "goal";
  };
})
