{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime3-dev = common {
    buildVersion = "3210";
    dev = true;
    x32sha256 = "1ngr4c8h2mafy96mi8dd3g8mg5r9ha1cpcd8p3gz7jwpbypvkkbv";
    x64sha256 = "0j65a4ylgga1qzc74wf3k5craghahma8hwqg3zs1rgzz601nl693";
  } { };

  sublime3 = common {
    buildVersion = "3211";
    x32sha256 = "0w9hba1nl2hv1mri418n7v0m321b6wqphb1knll23ldv5fb0j1j8";
    x64sha256 = "1vkldmimyjhbgplcd6r27gvk64rr7cparfd44hy6qdyzwsjqqg0b";
  } { };
}
