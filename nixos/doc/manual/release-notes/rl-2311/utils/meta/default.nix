{
  rl-filename = "rl-2311.section.md";
  title = "# Release 23.11 (“Tapir”, 2023.11/??) {#sec-release-23.11}";
  sections = [
    rec {
      id = "highlights";
      title = "## Highlights {#sec-release-23.11-highlights}";
      meta = import (./. + "/${id}.nix");
    }
    rec {
      id = "new-services";
      title = "## New Services {#sec-release-23.11-new-services}";
      meta = import (./. + "/${id}.nix");
    }
    rec {
      id = "incompatibilities";
      title = "## Backward Incompatibilities {#sec-release-23.11-incompatibilities}";
      meta = import (./. + "/${id}.nix");
    }
    rec {
      id = "other-changes";
      title = "## Other Notable Changes {#sec-release-23.11-notable-changes}";
      meta = import (./. + "/${id}.nix");
    }
    rec {
      id = "nixpkgs-internals";
      title = "## Nixpkgs internals {#sec-release-23.11-nixpkgs-internals}";
      meta = import (./. + "/${id}.nix");
    }
  ];
}
