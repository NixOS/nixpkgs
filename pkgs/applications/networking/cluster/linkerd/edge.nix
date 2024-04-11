{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.3.5";
  sha256 = "0sl4xxdsabma6q15fh0cqhgi5gmq3q2kzlw2wvcxhy78mm8qn8b0";
  vendorHash = "sha256-Oe8NMpcLGHmmlt3ceQQHHt1aV0zrWUI/TmCpyOVElCg=";
}
