{ nixos ? /etc/nixos/nixos
, nixpkgs ? /etc/nixos/nixpkgs
, networkExprs
, targetProperty ? "targetHost"
}:

let
  pkgs = import nixpkgs {};
  
  inherit (builtins) attrNames getAttr listToAttrs;
  inherit (pkgs.lib) concatMapStrings zipAttrs;
  
  networks = map (networkExpr: import networkExpr) networkExprs;
  
  network = zipAttrs networks;
  
  generateRollbackSucceededPhase = network: configs:
    concatMapStrings (configurationName: 
      let
	config = getAttr configurationName configs;
      in
      ''
        if [ "$rollback" != "$succeeded" ]
	then
	    ssh $NIX_SSHOPTS ${getAttr targetProperty (config.deployment)} nix-env -p /nix/var/nix/profiles/system --rollback
	    ssh $NIX_SSHOPTS ${getAttr targetProperty (config.deployment)} /nix/var/nix/profiles/system/bin/switch-to-configuration switch
	    
	    rollback=$((rollback + 1))
	fi
      ''
    ) (attrNames network)  
  ;
  
  generateDistributionPhase = network: configs:
    concatMapStrings (configurationName: 
      let
	config = getAttr configurationName configs;
      in
      ''
        echo "=== copy system closure to ${getAttr targetProperty (config.deployment)} ==="
        nix-copy-closure --to ${getAttr targetProperty (config.deployment)} ${config.system.build.toplevel}
      ''
    ) (attrNames network)
  ;
  
  generateActivationPhase = network: configs:
    concatMapStrings (configurationName: 
      let
	config = getAttr configurationName configs;
      in
      ''
        echo "=== activating system configuration on ${getAttr targetProperty (config.deployment)} ==="
	ssh $NIX_SSHOPTS ${getAttr targetProperty (config.deployment)} nix-env -p /nix/var/nix/profiles/system --set ${config.system.build.toplevel} || 
	  (ssh $NIX_SSHOPTS ${getAttr targetProperty (config.deployment)} nix-env -p /nix/var/nix/profiles/system --rollback; rollbackSucceeded)
	
        ssh $NIX_SSHOPTS ${getAttr targetProperty (config.deployment)} /nix/var/nix/profiles/system/bin/switch-to-configuration switch ||
	  ( ssh $NIX_SSHOPTS ${getAttr targetProperty (config.deployment)} nix-env -p /nix/var/nix/profiles/system --rollback
	    ssh $NIX_SSHOPTS ${getAttr targetProperty (config.deployment)} /nix/var/nix/profiles/system/bin/switch-to-configuration switch
	    rollbackSucceeded
	  )
	
	succeeded=$((succeeded + 1))
      ''
    ) (attrNames network)
  ;
  
  evaluateMachines = network:
    listToAttrs (map (configurationName:
      let
        modules = getAttr configurationName network;
      in
      { name = configurationName;
        value = (import "${nixos}/lib/eval-config.nix" {
          inherit nixpkgs;
          modules =
	    modules ++
            [ # Provide a default hostname and deployment target equal
              # to the attribute name of the machine in the model.
              { key = "set-default-hostname";
                networking.hostName = pkgs.lib.mkOverride 900 configurationName;
                deployment.targetHost = pkgs.lib.mkOverride 900 configurationName;
              }
            ];
          extraArgs = { nodes = evaluateMachines network; };
        }).config; }
    ) (attrNames (network)));

  configs = evaluateMachines network;
in
pkgs.stdenv.mkDerivation {
  name = "deploy-script";

  # This script has a zillion dependencies and is trivial to build, so
  # we don't want to build it remotely.
  preferLocalBuild = true;
  
  buildCommand = 
  ''
    ensureDir $out/bin
    cat > $out/bin/deploy-systems << "EOF"
    #! ${pkgs.stdenv.shell} -e
    
    rollbackSucceeded()
    {
        rollback=0
        ${generateRollbackSucceededPhase network configs}
    }
    
    # Distribution phase
    
    ${generateDistributionPhase network configs}
    
    # Activation phase
    
    succeeded=0
    
    ${generateActivationPhase network configs}
    EOF
    chmod +x $out/bin/deploy-systems
  '';
}
