{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  rec {
    sublime3-dev = common {
      buildVersion = "3170";
      x32sha256 = "04ll92mqnpvvaa161il6l02gvd0g0x95sci0yrywr6jzk6am1fzg";
      x64sha256 = "1snzjr000qrjyvzd876x5j66138glh0bff3c1b2cb2bfc88c3kzx";
    } {};

    sublime3 = common {
      buildVersion = "3170";
      x32sha256 = "04ll92mqnpvvaa161il6l02gvd0g0x95sci0yrywr6jzk6am1fzg";
      x64sha256 = "1snzjr000qrjyvzd876x5j66138glh0bff3c1b2cb2bfc88c3kzx";
    } {};
  }
