{ nixos ? /etc/nixos/nixos
, nixpkgs ? /etc/nixos/nixpkgs
, networkExpr
, infrastructureExpr
, targetProperty ? "hostname"
}:

let
  pkgs = import nixpkgs {};
  
  inherit (builtins) attrNames getAttr listToAttrs;
  inherit (pkgs.lib) concatMapStrings;
  
  network = import networkExpr;
  infrastructure = import infrastructureExpr;
  
  generateRollbackSucceededPhase = network: infrastructure: configs:
    concatMapStrings (configurationName: 
      let
        infrastructureElement = getAttr configurationName infrastructure;
	config = getAttr configurationName configs;
      in
      ''
        if [ "$rollback" != "$succeeded" ]
	then
	    ssh $NIX_SSHOPTS ${getAttr targetProperty infrastructureElement} nix-env -p /nix/var/nix/profiles/system --rollback
	    ssh $NIX_SSHOPTS ${getAttr targetProperty infrastructureElement} /nix/var/nix/profiles/bin/switch-to-configuration switch
	    
	    rollback=$((rollback + 1))
	fi
      ''
    ) (attrNames network)  
  ;
  
  generateDistributionPhase = network: infrastructure: configs:
    concatMapStrings (configurationName: 
      let
        infrastructureElement = getAttr configurationName infrastructure;
	config = getAttr configurationName configs;
      in
      ''
        echo "=== copy system closure to ${getAttr targetProperty infrastructureElement} ==="
        nix-copy-closure --to ${getAttr targetProperty infrastructureElement} ${config.system.build.toplevel}
      ''
    ) (attrNames network)
  ;
  
  generateActivationPhase = network: infrastructure: configs:
    concatMapStrings (configurationName: 
      let
        infrastructureElement = getAttr configurationName infrastructure;
	config = getAttr configurationName configs;
      in
      ''
        echo "=== activating system configuration on ${getAttr targetProperty infrastructureElement} ==="
	ssh $NIX_SSHOPTS ${getAttr targetProperty infrastructureElement} nix-env -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel} || 
	  (ssh $NIX_SSHOPTS ${getAttr targetProperty infrastructureElement} nix-env -p /nix/var/nix/profiles/system --rollback; rollbackSucceeded)
	
        ssh $NIX_SSHOPTS ${getAttr targetProperty infrastructureElement} /nix/var/nix/profiles/bin/switch-to-configuration switch ||
	  ( ssh $NIX_SSHOPTS ${getAttr targetProperty infrastructureElement} nix-env -p /nix/var/nix/profiles/system --rollback
	    ssh $NIX_SSHOPTS ${getAttr targetProperty infrastructureElement} /nix/var/nix/profiles/bin/switch-to-configuration switch
	    rollbackSucceeded
	  )
	
	succeeded=$((succeeded + 1))
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
  buildCommand = 
  ''
    ensureDir $out/bin
    cat > $out/bin/deploy-systems << "EOF"
    #! ${pkgs.stdenv.shell} -e
    
    rollbackSucceeded()
    {
        rollback=0
        ${generateRollbackSucceededPhase network infrastructure configs}
    }
    
    # Distribution phase
    
    ${generateDistributionPhase network infrastructure configs}
    
    # Activation phase
    
    succeeded=0
    
    ${generateActivationPhase network infrastructure configs}
    EOF
    chmod +x $out/bin/deploy-systems
  '';
}
