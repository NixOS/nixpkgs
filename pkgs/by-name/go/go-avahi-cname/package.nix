{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "go-avahi-cname";
  version = "2.5.0";

  src = fetchFromGitHub {
    repo = "go-avahi-cname";
    owner = "grishy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Tbvt/yXwNJVhO3k5ZIAsN3sSjBH7VJUb8NjBtmeOIk=";
  };

  vendorHash = "sha256-Q7/EH/o1q7HQo81nMI7lIKgJ0OOo257OvuAIphSUZVI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/grishy/go-avahi-cname/releases/tag/v${finalAttrs.version}";
    description = "mDNS publisher of subdomains";
    homepage = "https://github.com/grishy/go-avahi-cname";
    license = lib.licenses.mit;
    mainProgram = "go-avahi-cname";
    maintainers = [ lib.maintainers.magicquark ];
    platforms = lib.platforms.all;
  };
})
