{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.5.3";
  sha256 = "0yxn48ay5vz6ids9pgslnf1mlrbmfhfrp2p1g2k1akrwhq0qdjp0";
  vendorHash = "sha256-PD6lfjLDHj6lbu51wF5hfK1LmqvCsuxrRgI/c63YoSg=";
}
