{ callPackage
, symlinkJoin
, makeWrapper
, lib
, rxvt-unicode-unwrapped
, perlPackages
}:

let
  availablePlugins = import ../rxvt-unicode-plugins { inherit callPackage; };

  wrapper =
    { configure ? { availablePlugins, ... }:
      { plugins = builtins.attrValues availablePlugins;
        extraDeps = [ ];
        perlDeps = [ ];
      }
    }:

    let 
      config = configure { inherit availablePlugins; };
      plugins = config.plugins or (builtins.attrValues availablePlugins);
      extraDeps = config.extraDeps or [ ];
      perlDeps = (config.perlDeps or [ ]) ++ lib.concatMap (p: p.perlPackages or [ ]) plugins;
    in
      symlinkJoin {
        name = "rxvt-unicode-${rxvt-unicode-unwrapped.version}";

        paths = [ rxvt-unicode-unwrapped ] ++ plugins ++ extraDeps;

        buildInputs = [ makeWrapper ];

        postBuild = ''
          wrapProgram $out/bin/urxvt \
            --prefix PERL5LIB : "${perlPackages.makePerlPath perlDeps}" \
            --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
          wrapProgram $out/bin/urxvtd \
            --prefix PERL5LIB : "${perlPackages.makePerlPath perlDeps}" \
            --suffix-each URXVT_PERL_LIB ':' "$out/lib/urxvt/perl"
        '';

        passthru.plugins = plugins;
      };

in
  lib.makeOverridable wrapper { }
