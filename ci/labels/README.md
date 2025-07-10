To test the labeler locally:
- Provide `gh` on `PATH` and make sure it's authenticated.
- Enter `nix-shell` in `./ci/labels`.
- Run `./run.js OWNER REPO`, where OWNER is your username or "NixOS" and REPO the name of your fork or "nixpkgs".
