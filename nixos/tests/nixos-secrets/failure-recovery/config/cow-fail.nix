{
  imports = [ ./cow-good.nix ];
  secrets.store.derived.backend = "fail";
}
