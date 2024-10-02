{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.9.2";
  sha256 = "0bac5pwh741z7ly8abz92mydrhps2rlp4nkf3a4yxm7gj25gbqb1";
  vendorHash = "sha256-zKKgMcuHowU3Sft8QX0VJF+zXCVRyNC10k8nXwzTfYs=";
}
