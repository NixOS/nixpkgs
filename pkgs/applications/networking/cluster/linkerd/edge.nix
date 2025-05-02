{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.4.5";
  sha256 = "0cxjilxsvbwahqh3wb3cw4z8fmq6lhxi531abrncs74kgasgcfam";
  vendorHash = "sha256-YxavLLYppV991AgFb2WaQDbqnsr3UfrvWefvkSf+W1Q=";
}
