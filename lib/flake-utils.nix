{ nixpkgs, systems }:
rec {
  /* mapDefaultSystems using default supported systems
     Usage in a nix flake:
       {
         description = "Flake demo";

         inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

         outputs = { self, nixpkgs }:
           nixpkgs.lib.mapDefaultSystems (pkgs:
             {
               packages = {
                 hello = pkgs.hello;
               };
               defaultPackage = self.packages.hello;
             }
           );
       }

     Type: mapDefaultSystems :: (attrset -> attrset) -> attrset

     Example:
       nixpkgs.lib.mapDefaultSystems (pkgs: {
         defaultPackage = packages.hello;
       })
       => {
         defaultPackage = {
           aarch64-linux.hello = <<derivation /nix/store/...-hello-2.10.drv>>,
           ...
           x86_64-darwin.hello = <<derivation /nix/store/...-hello-2.10.drv>>,
           x86_64-linux.hello = <<derivation /nix/store/...-hello-2.10.drv>>,
         };
       }
  */
  mapDefaultSystems = mapSystems systems;

  /* Builds a map from <attr>=value to <attr>.<system>=value for each system.
     See `mapDefaultSystems` for a full example

     Type: mapSystems :: [string] -> (attrset -> attrset)

     Example:
       mapSystems ["x86_64-linux"] (pkgs: { hello = 42; })
       => { hello = { x86_64-linux = 42; }; }
  */
  mapSystems = systems: f:
    let
      op = attrs: system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          ret = f pkgs;
          op = attrs: key:
            attrs //
            {
              ${key} = (attrs.${key} or { }) // { ${system} = ret.${key}; };
            }
          ;
        in
        builtins.foldl' op attrs (builtins.attrNames ret);
    in
      builtins.foldl' op { } systems;
}
