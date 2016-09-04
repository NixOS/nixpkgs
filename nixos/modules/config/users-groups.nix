{ config, lib, utils, pkgs, ... }:

with lib;

let
  ids = config.ids;
  cfg = config.users;

  passwordDescription = ''
    The options <option>hashedPassword</option>,
    <option>password</option> and <option>passwordFile</option>
    controls what password is set for the user.
    <option>hashedPassword</option> overrides both
    <option>password</option> and <option>passwordFile</option>.
    <option>password</option> overrides <option>passwordFile</option>.
    If none of these three options are set, no password is assigned to
    the user, and the user will not be able to do password logins.
    If the option <option>users.mutableUsers</option> is true, the
    password defined in one of the three options will only be set when
    the user is created for the first time. After that, you are free to
    change the password with the ordinary user management commands. If
    <option>users.mutableUsers</option> is false, you cannot change
    user passwords, they will always be set according to the password
    options.
  '';

  hashedPasswordDescription = ''
    To generate hashed password install <literal>mkpasswd</literal>
    package and run <literal>mkpasswd -m sha-512</literal>.
  '';

  userOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = types.str;
        description = ''
          The name of the user account. If undefined, the name of the
          attribute set will be used.
        '';
      };

      description = mkOption {
        type = types.str;
        default = "";
        example = "Alice Q. User";
        description = ''
          A short description of the user account, typically the
          user's full name.  This is actually the “GECOS” or “comment”
          field in <filename>/etc/passwd</filename>.
        '';
      };

      uid = mkOption {
        type = with types; nullOr int;
        default = null;
        description = ''
          The account UID. If the UID is null, a free UID is picked on
          activation.
        '';
      };

      isSystemUser = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Indicates if the user is a system user or not. This option
          only has an effect if <option>uid</option> is
          <option>null</option>, in which case it determines whether
          the user's UID is allocated in the range for system users
          (below 500) or in the range for normal users (starting at
          1000).
        '';
      };

      isNormalUser = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Indicates whether this is an account for a “real” user. This
          automatically sets <option>group</option> to
          <literal>users</literal>, <option>createHome</option> to
          <literal>true</literal>, <option>home</option> to
          <filename>/home/<replaceable>username</replaceable></filename>,
          <option>useDefaultShell</option> to <literal>true</literal>,
          and <option>isSystemUser</option> to
          <literal>false</literal>.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = "The user's primary group.";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "The user's auxiliary groups.";
      };

      home = mkOption {
        type = types.path;
        default = "/var/empty";
        description = "The user's home directory.";
      };

      cryptHomeLuks = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          Path to encrypted luks device that contains
          the user's home directory.
        '';
      };

      shell = mkOption {
        type = types.either types.shellPackage types.path;
        default = pkgs.nologin;
        defaultText = "pkgs.nologin";
        example = literalExample "pkgs.bashInteractive";
        description = ''
          The path to the user's shell. Can use shell derivations,
          like <literal>pkgs.bashInteractive</literal>. Don’t
          forget to enable your shell in
          <literal>programs</literal> if necessary,
          like <code>programs.zsh.enable = true;</code>.
        '';
      };

      subUidRanges = mkOption {
        type = types.listOf types.optionSet;
        default = [];
        example = [
          { startUid = 1000; count = 1; }
          { startUid = 100001; count = 65534; }
        ];
        options = [ subordinateUidRange ];
        description = ''
          Subordinate user ids that user is allowed to use.
          They are set into <filename>/etc/subuid</filename> and are used
          by <literal>newuidmap</literal> for user namespaces.
        '';
      };

      subGidRanges = mkOption {
        type = types.listOf types.optionSet;
        default = [];
        example = [
          { startGid = 100; count = 1; }
          { startGid = 1001; count = 999; }
        ];
        options = [ subordinateGidRange ];
        description = ''
          Subordinate group ids that user is allowed to use.
          They are set into <filename>/etc/subgid</filename> and are used
          by <literal>newgidmap</literal> for user namespaces.
        '';
      };

      createHome = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, the home directory will be created automatically. If this
          option is true and the home directory already exists but is not
          owned by the user, directory owner and group will be changed to
          match the user.
        '';
      };

      useDefaultShell = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, the user's shell will be set to
          <option>users.defaultUserShell</option>.
        '';
      };

      hashedPassword = mkOption {
        type = with types; uniq (nullOr str);
        default = null;
        description = ''
          Specifies the hashed password for the user.
          ${passwordDescription}
          ${hashedPasswordDescription}
        '';
      };

      password = mkOption {
        type = with types; uniq (nullOr str);
        default = null;
        description = ''
          Specifies the (clear text) password for the user.
          Warning: do not set confidential information here
          because it is world-readable in the Nix store. This option
          should only be used for public accounts.
          ${passwordDescription}
        '';
      };

      passwordFile = mkOption {
        type = with types; uniq (nullOr string);
        default = null;
        description = ''
          The full path to a file that contains the user's password. The password
          file is read on each system activation. The file should contain
          exactly one line, which should be the password in an encrypted form
          that is suitable for the <literal>chpasswd -e</literal> command.
          ${passwordDescription}
        '';
      };

      initialHashedPassword = mkOption {
        type = with types; uniq (nullOr str);
        default = null;
        description = ''
          Specifies the initial hashed password for the user, i.e. the
          hashed password assigned if the user does not already
          exist. If <option>users.mutableUsers</option> is true, the
          password can be changed subsequently using the
          <command>passwd</command> command. Otherwise, it's
          equivalent to setting the <option>hashedPassword</option> option.

          ${hashedPasswordDescription}
        '';
      };

      initialPassword = mkOption {
        type = with types; uniq (nullOr str);
        default = null;
        description = ''
          Specifies the initial password for the user, i.e. the
          password assigned if the user does not already exist. If
          <option>users.mutableUsers</option> is true, the password
          can be changed subsequently using the
          <command>passwd</command> command. Otherwise, it's
          equivalent to setting the <option>password</option>
          option. The same caveat applies: the password specified here
          is world-readable in the Nix store, so it should only be
          used for guest accounts or passwords that will be changed
          promptly.
        '';
      };

    };

    config = mkMerge
      [ { name = mkDefault name;
          shell = mkIf config.useDefaultShell (mkDefault cfg.defaultUserShell);
        }
        (mkIf config.isNormalUser {
          group = mkDefault "users";
          createHome = mkDefault true;
          home = mkDefault "/home/${name}";
          useDefaultShell = mkDefault true;
          isSystemUser = mkDefault false;
        })
        # If !mutableUsers, setting ‘initialPassword’ is equivalent to
        # setting ‘password’ (and similarly for hashed passwords).
        (mkIf (!cfg.mutableUsers && config.initialPassword != null) {
          password = mkDefault config.initialPassword;
        })
        (mkIf (!cfg.mutableUsers && config.initialHashedPassword != null) {
          hashedPassword = mkDefault config.initialHashedPassword;
        })
      ];

  };

  groupOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = types.str;
        description = ''
          The name of the group. If undefined, the name of the attribute set
          will be used.
        '';
      };

      gid = mkOption {
        type = with types; nullOr int;
        default = null;
        description = ''
          The group GID. If the GID is null, a free GID is picked on
          activation.
        '';
      };

      members = mkOption {
        type = with types; listOf string;
        default = [];
        description = ''
          The user names of the group members, added to the
          <literal>/etc/group</literal> file.
        '';
      };

    };

    config = {
      name = mkDefault name;
    };

  };

  subordinateUidRange = {
    startUid = mkOption {
      type = types.int;
      description = ''
        Start of the range of subordinate user ids that user is
        allowed to use.
      '';
    };
    count = mkOption {
      type = types.int;
      default = 1;
      description = ''Count of subordinate user ids'';
    };
  };

  subordinateGidRange = {
    startGid = mkOption {
      type = types.int;
      description = ''
        Start of the range of subordinate group ids that user is
        allowed to use.
      '';
    };
    count = mkOption {
      type = types.int;
      default = 1;
      description = ''Count of subordinate group ids'';
    };
  };

  mkSubuidEntry = user: concatStrings (
    map (range: "${user.name}:${toString range.startUid}:${toString range.count}\n")
      user.subUidRanges);

  subuidFile = concatStrings (map mkSubuidEntry (attrValues cfg.users));

  mkSubgidEntry = user: concatStrings (
    map (range: "${user.name}:${toString range.startGid}:${toString range.count}\n")
        user.subGidRanges);

  subgidFile = concatStrings (map mkSubgidEntry (attrValues cfg.users));

  idsAreUnique = set: idAttr: !(fold (name: args@{ dup, acc }:
    let
      id = builtins.toString (builtins.getAttr idAttr (builtins.getAttr name set));
      exists = builtins.hasAttr id acc;
      newAcc = acc // (builtins.listToAttrs [ { name = id; value = true; } ]);
    in if dup then args else if exists
      then builtins.trace "Duplicate ${idAttr} ${id}" { dup = true; acc = null; }
      else { dup = false; acc = newAcc; }
    ) { dup = false; acc = {}; } (builtins.attrNames set)).dup;

  uidsAreUnique = idsAreUnique (filterAttrs (n: u: u.uid != null) cfg.users) "uid";
  gidsAreUnique = idsAreUnique (filterAttrs (n: g: g.gid != null) cfg.groups) "gid";

  spec = pkgs.writeText "users-groups.json" (builtins.toJSON {
    inherit (cfg) mutableUsers;
    users = mapAttrsToList (_: u:
      { inherit (u)
          name uid group description home createHome isSystemUser
          password passwordFile hashedPassword
          initialPassword initialHashedPassword;
        shell = utils.toShellPath u.shell;
      }) cfg.users;
    groups = mapAttrsToList (n: g:
      { inherit (g) name gid;
        members = g.members ++ (mapAttrsToList (n: u: u.name) (
          filterAttrs (n: u: elem g.name u.extraGroups) cfg.users
        ));
      }) cfg.groups;
  });

  systemShells =
    let
      shells = mapAttrsToList (_: u: u.shell) cfg.users;
    in
      filter types.shellPackage.check shells;

in {

  ###### interface

  options = {

    users.mutableUsers = mkOption {
      type = types.bool;
      default = true;
      description = ''
        If set to <literal>true</literal>, you are free to add new users and groups to the system
        with the ordinary <literal>useradd</literal> and
        <literal>groupadd</literal> commands. On system activation, the
        existing contents of the <literal>/etc/passwd</literal> and
        <literal>/etc/group</literal> files will be merged with the
        contents generated from the <literal>users.users</literal> and
        <literal>users.groups</literal> options.
        The initial password for a user will be set
        according to <literal>users.users</literal>, but existing passwords
        will not be changed.

        <warning><para>
        If set to <literal>false</literal>, the contents of the user and
        group files will simply be replaced on system activation. This also
        holds for the user passwords; all changed
        passwords will be reset according to the
        <literal>users.users</literal> configuration on activation.
        </para></warning>
      '';
    };

    users.enforceIdUniqueness = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to require that no two users/groups share the same uid/gid.
      '';
    };

    users.users = mkOption {
      default = {};
      type = types.loaOf types.optionSet;
      example = {
        alice = {
          uid = 1234;
          description = "Alice Q. User";
          home = "/home/alice";
          createHome = true;
          group = "users";
          extraGroups = ["wheel"];
          shell = "/bin/sh";
        };
      };
      description = ''
        Additional user accounts to be created automatically by the system.
        This can also be used to set options for root.
      '';
      options = [ userOpts ];
    };

    users.groups = mkOption {
      default = {};
      example =
        { students.gid = 1001;
          hackers = { };
        };
      type = types.loaOf types.optionSet;
      description = ''
        Additional groups to be created automatically by the system.
      '';
      options = [ groupOpts ];
    };

    # FIXME: obsolete - will remove.
    security.initialRootPassword = mkOption {
      type = types.str;
      default = "!";
      example = "";
      visible = false;
    };

  };


  ###### implementation

  config = {

    users.users = {
      root = {
        uid = ids.uids.root;
        description = "System administrator";
        home = "/root";
        shell = mkDefault cfg.defaultUserShell;
        group = "root";
        initialHashedPassword = mkDefault config.security.initialRootPassword;
      };
      nobody = {
        uid = ids.uids.nobody;
        description = "Unprivileged account (don't use!)";
        group = "nogroup";
      };
    };

    # Install all the user shells
    environment.systemPackages = systemShells;

    users.groups = {
      root.gid = ids.gids.root;
      wheel.gid = ids.gids.wheel;
      disk.gid = ids.gids.disk;
      kmem.gid = ids.gids.kmem;
      tty.gid = ids.gids.tty;
      floppy.gid = ids.gids.floppy;
      uucp.gid = ids.gids.uucp;
      lp.gid = ids.gids.lp;
      cdrom.gid = ids.gids.cdrom;
      tape.gid = ids.gids.tape;
      audio.gid = ids.gids.audio;
      video.gid = ids.gids.video;
      dialout.gid = ids.gids.dialout;
      nogroup.gid = ids.gids.nogroup;
      users.gid = ids.gids.users;
      nixbld.gid = ids.gids.nixbld;
      utmp.gid = ids.gids.utmp;
      adm.gid = ids.gids.adm;
      input.gid = ids.gids.input;
    };

    system.activationScripts.users = stringAfter [ "etc" ]
      ''
        ${pkgs.perl}/bin/perl -w \
          -I${pkgs.perlPackages.FileSlurp}/lib/perl5/site_perl \
          -I${pkgs.perlPackages.JSON}/lib/perl5/site_perl \
          ${./update-users-groups.pl} ${spec}
      '';

    # for backwards compatibility
    system.activationScripts.groups = stringAfter [ "users" ] "";

    environment.etc."subuid" = {
      text = subuidFile;
      mode = "0644";
    };
    environment.etc."subgid" = {
      text = subgidFile;
      mode = "0644";
    };

    assertions = [
      { assertion = !cfg.enforceIdUniqueness || (uidsAreUnique && gidsAreUnique);
        message = "UIDs and GIDs must be unique!";
      }
      { # If mutableUsers is false, to prevent users creating a
        # configuration that locks them out of the system, ensure that
        # there is at least one "privileged" account that has a
        # password or an SSH authorized key. Privileged accounts are
        # root and users in the wheel group.
        assertion = !cfg.mutableUsers ->
          any id (mapAttrsToList (name: cfg:
            (name == "root"
             || cfg.group == "wheel"
             || elem "wheel" cfg.extraGroups)
            &&
            ((cfg.hashedPassword != null && cfg.hashedPassword != "!")
             || cfg.password != null
             || cfg.passwordFile != null
             || cfg.openssh.authorizedKeys.keys != []
             || cfg.openssh.authorizedKeys.keyFiles != [])
          ) cfg.users);
        message = ''
          Neither the root account nor any wheel user has a password or SSH authorized key.
          You must set one to prevent being locked out of your system.'';
      }
    ];

  };

  imports =
    [ (mkAliasOptionModule [ "users" "extraUsers" ] [ "users" "users" ])
      (mkAliasOptionModule [ "users" "extraGroups" ] [ "users" "groups" ])
    ];
}
