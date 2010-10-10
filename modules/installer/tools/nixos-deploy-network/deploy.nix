{ nixos ? /etc/nixos/nixos
, nixpkgs ? /etc/nixos/nixpkgs
, networkExpr
, infrastructureExpr
}:

let
  pkgs = import nixpkgs {};
  
  inherit (builtins) attrNames getAttr listToAttrs concatMapStrings;
  
  network = import networkExpr;
  infrastructure = import infrastructureExpr;
 
  generateScript = network: infrastructure: configs:
    concatMapStrings (configurationName: 
      let
        infrastructureElement = getAttr configurationName infrastructure;
	config = getAttr configurationName configs;
      in
      ''
        echo "=== upgrading ${infrastructureElement.hostName} ==="
        nix-copy-closure --to ${infrastructureElement.hostName} ${config.system.build.toplevel} \
        && ssh $NIX_SSHOPTS ${infrastructureElement.hostName} nix-env -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel} \
        && ssh $NIX_SSHOPTS ${infrastructureElement.hostName} ${config.system.build.toplevel}/bin/switch-to-configuration switch \
        && { succeeded=$((succeeded + 1)); } \
        || { failed=$((failed + 1)); echo 'WARNING: upgrade of ${infrastructureElement.hostName} failed!'; }
      ''
    ) (attrNames network)
  ;

  evaluateMachines = network: infrastructure:
    listToAttrs (map (configurationName:
      let
        configuration = getAttr configurationName network;
        system = (getAttr configurationName infrastructure).system;
      in
      { name = configurationName;
        value = (import "${nixos}/lib/eval-config.nix" {
          inherit nixpkgs system;
          modules = [ configuration ];
          extraArgs = evaluateMachines network infrastructure;
        }).config; }
    ) (attrNames (network)))
  ;

  configs = evaluateMachines network infrastructure;
in
pkgs.stdenv.mkDerivation {
  name = "deploy-script";
  buildCommand = ''
    ensureDir $out/bin
    cat > $out/bin/deploy-systems << "EOF"
    #! ${pkgs.stdenv.shell} -e
    failed=0; succeeded=0
    ${generateScript network infrastructure configs}
    echo "Upgrade of $failed machines failed, $succeeded machines succeeded.";
    EOF
    chmod +x $out/bin/deploy-systems
  '';
}
