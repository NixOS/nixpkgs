{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "vm";
  version = "0.14.0";

  sha256 = "013gq7jn556nkk1nq6zzh9nmp3fb36jd7ndzvyq3qryw7khzkagc";

  description = "Programmable virtual machine LV2 plugin";
})
