## Handling dependencies {#sec-systemd-handling-dependencies}

When a systemd service A depends on another service B.
There are 3 choices to make
wants vs requires vs bindsTo:
- use `wants = [ "B" ];`, if service A can start even if B fails. Systemd will try to start B but will start A even in case of a failure of B. 
- use `requires = [ "B" ];`, if service A will not start without B. Systemd will try to start B and will not start A in case B fails. 
- use `bindsTo = [ "B" ];`, if service A should be shutdown in case of a failure of B.

After:
- use `after = [ "B" ];`, if service A needs B to active before it is started. Note that with this setting, if you shutdown B, A will be shut down first.

PartOf:
- use `partOf = [ "B" ];`, if service A needs to re-started when service B is.

Note that `wants,requires,bindsTo` are orthogonal to `after`. The most common occurence in nixpkgs is `requires` and `after`.

### Examples {#sec-systemd-handling-dependencies-examples}

- Web-app dependency on a database. If the web-app cannot start without the database, use `requires` and `after`. If you would rather have it operate even without a database use `wants` and `after`. [example in nixpkgs](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/lemmy.nix#L169)
- Database migration and setup script for a web-app. It is common to make a service for database setup and migration. This service should be `partOf` the webapp service as everytime the webapp is restarted, this service should be restarted as well.
[example in nixpkgs](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/lemmy.nix#L214)
- A web-app has two separate services, a UI and a server. The ui `requires` `after` the server. [example in nixpkgs](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/lemmy.nix#L205) 


Note there are many other settings, for a complete reference and more detailed explanations, see the [systemd manual section](https://man.archlinux.org/man/systemd.unit.5#%5BUNIT%5D_SECTION_OPTIONS)