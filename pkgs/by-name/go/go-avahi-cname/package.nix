{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:
buildGo126Module (finalAttrs: {
  pname = "go-avahi-cname";
  version = "2.6.1";

  src = fetchFromGitHub {
    repo = "go-avahi-cname";
    owner = "grishy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MeEytTRZF5zpfWYNzvqiMdjvf6IJpS1t5V7+D08GjAY=";
  };

  vendorHash = "sha256-vbIHB9u9Ftwdw7rHnj6rkk/ABmESNvOgp0hixeWVnkI=";

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) go-avahi-cname;
    };
  };

  meta = {
    changelog = "https://github.com/grishy/go-avahi-cname/releases/tag/v${finalAttrs.version}";
    description = "mDNS publisher of subdomains";
    homepage = "https://github.com/grishy/go-avahi-cname";
    license = lib.licenses.mit;
    mainProgram = "go-avahi-cname";
    maintainers = [ lib.maintainers.magicquark ];
    platforms = lib.platforms.linux;
  };
})
