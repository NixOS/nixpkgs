#https://github.com/NixOS/nixpkgs/blob/nixos-25.05/pkgs/build-support/go/module.nix
{ buildGoModule, fetchFromGitHub, }:
let
  proxyns = buildGoModule rec {
    name = "proxy-ns";
    version = "2.2.2";
    vendorHash = null;
    src = fetchFromGitHub {
      owner = "OkamiW";
      repo = name;
      rev = "v${version}";
      hash = "";
    };
    ldflags = [ "-s" "-w" "-X main.SysConfDir=${placeholder "out"}" ];
    GOFLAGS = [
      "-buildvcs=false"
      #"-trimpath" added by default by buildGoModule
    ];
    postInstall = ''
      mkdir -p $out/etc/proxy-ns
      '';
  };
in
proxyns
