# This module generates the nixos-checkout script, which replaces the
# NixOS and Nixpkgs source trees in /etc/nixos/{nixos,nixpkgs} with
# Subversion checkouts.

{config, pkgs, ...}:

with pkgs.lib;

let

  options = {

    # !!! These option (and their implementation) seems
    # over-engineering.  nixos-checkout was never intended to be a
    # generic, "check out anything that the user want to have from any
    # version management system whatsoever", but merely a trivial
    # convenience script to checkout the NixOS and Nixpkgs trees
    # during or after a NixOS installation.
    installer.repos.nixos = mkOption {
      default = [ { type  = "svn"; } ];
      example =
        [ { type = "svn"; url = "https://svn.nixos.org/repos/nix/nixos/branches/stdenv-updates"; target = "/etc/nixos/nixos-stdenv-updates"; }
          { type = "git"; initialize = ''git clone git://mawercer.de/nixos $target''; update = "git pull origin"; target = "/etc/nixos/nixos-git"; }
        ];
      description = ''
        The NixOS repository from which the system will be built.
        <command>nixos-checkout</command> will update all working
        copies of the given repositories,
        <command>nixos-rebuild</command> will use the first item
        which has the attribute <literal>default = true</literal>
        falling back to the first item. The type defines the
        repository tool added to the path. It also defines a "valid"
        repository.  If the target directory already exists and it's
        not valid it will be moved to the backup location
        <filename><replaceable>dir</replaceable>-date</filename>.
        For svn the default target and repositories are
        <filename>/etc/nixos/nixos</filename> and
        <filename>https://svn.nixos.org/repos/nix/nixos/trunk</filename>.
        For git repositories update is called after initialization
        when the repo is initialized.  The initialize code is run
        from working directory dirname
        <replaceable>target</replaceable> and should create the
        directory
        <filename><replaceable>dir</replaceable></filename>.  For
        the executables used see <option>repoTypes</option>.
      '';
    };

    installer.repos.nixpkgs = mkOption {
      default = [ { type  = "svn"; }  ];
      description = "same as <option>repos.nixos</option>";
    };

    installer.repoTypes = mkOption {
      default = {
        svn = { valid = "[ -d .svn ]"; env = [ pkgs.coreutils pkgs.subversion ]; };
        git = { valid = "[ -d .git ]"; env = [ pkgs.coreutils pkgs.git pkgs.gnused /*  FIXME: use full path to sed in nix-pull */ ]; };
      };
      description = ''
        Defines, for each supported version control system
        (e.g. <literal>git</literal>), the dependencies for the
        mechanism, as well as a test used to determine whether a
        directory is a checkout created by that version control
        system.
      '';
    };
      
  };


  ### implementation

  # prepareRepoAttrs adds svn defaults and preparse the repo attribute sets so that they
  # returns in any case:
  # { type = git/svn; 
  #   target = path;
  #   initialize = cmd; # must create target dir, dirname target will exist
  #   update = cmd;     # pwd will be target
  #   default = true/false;
  # }
  prepareRepoAttrs = repo : attrs :
    assert (isAttrs attrs);
    assert (repo + "" == repo); # assert repo is a string
    if (! (attrs ? type)) then 
      throw "repo type is missing of : ${showVal attrs}"
    # prepare svn repo
    else if attrs.type == "svn" then
      let a = { # add svn defaults
                url = "https://svn.nixos.org/repos/nix/${repo}/trunk";
                target = "/etc/nixos/${repo}";
              } // attrs; in
      rec { 
        inherit (a) type target;
        default =  if a ? default then a.default else false;
        initialize = "svn co ${a.url} ${a.target}"; 
        update = initialize; # co is just as fine as svn update
     }
    # prepare git repo
    else  if attrs.type == "git" then # sanity check for existing attrs
      assert (all id (map ( attr : if hasAttr attr attrs then true 
                                     else throw "git repository item is missing attribute ${attr}")
                          [ "target" "initialize" "update" ]
                      ));
    let t = escapeShellArg attrs.target; in
    rec {
      inherit (attrs) type target;
      default =  if attrs ? default then attrs.default else false;
      update = "cd ${t}; ${attrs.update}";
      initialize =  ''
    cd $(dirname ${t}); ${attrs.initialize}
    [ -d ${t} ] || { echo "git initialize failed to create target directory ${t}"; exit 1; }
    ${update}'';
    }
    else throw "unkown repo type ${attrs.type}";

  # apply prepareRepoAttrs on each repo definition
  repos = mapAttrs ( repo : list : map (x : (prepareRepoAttrs repo x) // { inherit repo; } ) list ) config.installer.repos;

  # function returning the default repo (first one having attribute default or head of list)
  defaultRepo = list : head ( (filter ( attrs : attrs ? default && attrs.default == true ) list)
                              ++ list );

  # creates the nixos-checkout script 
  nixosCheckout = pkgs.substituteAll {
    name = "nixos-checkout";
    dir = "bin";
    isExecutable = true;
    src = pkgs.writeScript "nixos-checkout" (''
          #! @shell@ -e
          # this file is automatically generated from nixos configuration file settings (installer.repos)
          backupTimestamp=$(date "+%Y%m%d%H%M%S")
          '' + concatMapStrings ( attrs :
                let repoType = builtins.getAttr attrs.type config.installer.repoTypes; 
                    target = escapeShellArg attrs.target; in
                ''
                  # ${attrs.type} repo ${target}
                  PATH=
                  for path in ${toString repoType.env}; do
                    PATH=$PATH:$path/bin:$path/sbin
                  done
                  if [ -d  ${target} ] && { cd ${target} && { ${ repoType.valid}; }; }; then
                      echo; echo '>>  ' updating ${attrs.type} repo ${target}
                      set -x; ${attrs.update}; set +x
                  else # [ make backup and ] initialize
                      [ -e ${target} ] && mv ${target} ${target}-$backupTimestamp
                      target=${target}
                      [ -d "$(dirname ${target})" ] || mkdir -p  "$(dirname ${target})"
                      echo; echo '>>  'initializing ${attrs.type} repo ${target}
                      set -x; ${attrs.initialize}; set +x
                  fi
                ''
              ) # flatten all repo definition to one list adding the repository
               ( concatLists  (flattenAttrs repos) )
      );
   };
  
  
in

{
  require = options;

  environment.systemPackages = [nixosCheckout];
}
