{ config, lib, utils, pkgs, ... }:

with lib;

let
  ids = config.ids;
  cfg = config.users;

  # Check whether a password hash will allow login.
  allowsLogin = hash:
    hash == "" # login without password
    || !(lib.elem hash
      [ null   # password login disabled
        "!"    # password login disabled
        "!!"   # a variant of "!"
        "*"    # password unset
      ]);

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
    To generate a hashed password run <literal>mkpasswd -m sha-512</literal>.

    If set to an empty string (<literal>""</literal>), this user will
    be able to log in without being asked for a password (but not via remote
    services such as SSH, or indirectly via <command>su</command> or
    <command>sudo</command>). This should only be used for e.g. bootable
    live systems. Note: this is different from setting an empty password,
    which ca be achieved using <option>users.users.&lt;name?&gt;.password</option>.

    If set to <literal>null</literal> (default) this user will not
    be able to log in using a password (i.e. via <command>login</command>
    command).
  '';

  userOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = types.str;
        apply = x: assert (builtins.stringLength x < 32 || abort "Username '${x}' is longer than 31 characters which is not allowed!"); x;
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
        apply = x: assert (builtins.stringLength x < 32 || abort "Group name '${x}' is longer than 31 characters which is not allowed!"); x;
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

      pamMount = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = ''
          Attributes for user's entry in
          <filename>pam_mount.conf.xml</filename>.
          Useful attributes might include <code>path</code>,
          <code>options</code>, <code>fstype</code>, and <code>server</code>.
          See <link
          xlink:href="http://pam-mount.sourceforge.net/pam_mount.conf.5.html" />
          for more information.
        '';
      };

      shell = mkOption {
        type = types.either types.shellPackage types.path;
        default = pkgs.shadow;
        defaultText = "pkgs.shadow";
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
        type = with types; listOf (submodule subordinateUidRange);
        default = [];
        example = [
          { startUid = 1000; count = 1; }
          { startUid = 100001; count = 65534; }
        ];
        description = ''
          Subordinate user ids that user is allowed to use.
          They are set into <filename>/etc/subuid</filename> and are used
          by <literal>newuidmap</literal> for user namespaces.
        '';
      };

      subGidRanges = mkOption {
        type = with types; listOf (submodule subordinateGidRange);
        default = [];
        example = [
          { startGid = 100; count = 1; }
          { startGid = 1001; count = 999; }
        ];
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
          Whether to create the home directory and ensure ownership as well as
          permissions to match the user.
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
        type = with types; nullOr str;
        default = null;
        description = ''
          Specifies the hashed password for the user.
          ${passwordDescription}
          ${hashedPasswordDescription}
        '';
      };

      password = mkOption {
        type = with types; nullOr str;
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
        type = with types; nullOr str;
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
        type = with types; nullOr str;
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
        type = with types; nullOr str;
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

      packages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExample "[ pkgs.firefox pkgs.thunderbird ]";
        description = ''
          The set of packages that should be made available to the user.
          This is in contrast to <option>environment.systemPackages</option>,
          which adds packages to all users.
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
          home = mkDefault "/home/${config.name}";
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

  groupOpts = { name, ... }: {

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
        type = with types; listOf str;
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
    options = {
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
  };

  subordinateGidRange = {
    options = {
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
  };

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
          isNormalUser subUidRanges subGidRanges
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
  imports = [
    (mkAliasOptionModule [ "users" "extraUsers" ] [ "users" "users" ])
    (mkAliasOptionModule [ "users" "extraGroups" ] [ "users" "groups" ])
    (mkChangedOptionModule
      [ "security" "initialRootPassword" ]
      [ "users" "users" "root" "initialHashedPassword" ]
      (cfg: if cfg.security.initialRootPassword == "!"
            then null
            else cfg.security.initialRootPassword))
  ];

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
      type = with types; attrsOf (submodule userOpts);
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
    };

    users.groups = mkOption {
      default = {};
      example =
        { students.gid = 1001;
          hackers = { };
        };
      type = with types; attrsOf (submodule groupOpts);
      description = ''
        Additional groups to be created automatically by the system.
      '';
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
      };
      nobody = {
        uid = ids.uids.nobody;
        description = "Unprivileged account (don't use!)";
        group = "nogroup";
      };
    };

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
      kvm.gid = ids.gids.kvm;
      render.gid = ids.gids.render;
      shadow.gid = ids.gids.shadow;
    };

    system.activationScripts.users = stringAfter [ "stdio" ]
      ''
        install -m 0700 -d /root
        install -m 0755 -d /home

        ${pkgs.perl}/bin/perl -w \
          -I${pkgs.perlPackages.FileSlurp}/${pkgs.perl.libPrefix} \
          -I${pkgs.perlPackages.JSON}/${pkgs.perl.libPrefix} \
          ${./update-users-groups.pl} ${spec}
      '';

    # for backwards compatibility
    system.activationScripts.groups = stringAfter [ "users" ] "";

    # Install all the user shells
    environment.systemPackages = systemShells;

    environment.etc = (mapAttrs' (name: { packages, ... }: {
      name = "profiles/per-user/${name}";
      value.source = pkgs.buildEnv {
        name = "user-environment";
        paths = packages;
        inherit (config.environment) pathsToLink extraOutputsToInstall;
        inherit (config.system.path) ignoreCollisions postBuild;
      };
    }) (filterAttrs (_: u: u.packages != []) cfg.users));

    environment.profiles = [
      "$HOME/.nix-profile"
      "/etc/profiles/per-user/$USER"
    ];

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
          any id ((mapAttrsToList (name: cfg:
            (name == "root"
             || cfg.group == "wheel"
             || elem "wheel" cfg.extraGroups)
            &&
            (allowsLogin cfg.hashedPassword
             || cfg.password != null
             || cfg.passwordFile != null
             || cfg.openssh.authorizedKeys.keys != []
             || cfg.openssh.authorizedKeys.keyFiles != [])
          ) cfg.users) ++ [
            config.security.googleOsLogin.enable
          ]);
        message = ''
          Neither the root account nor any wheel user has a password or SSH authorized key.
          You must set one to prevent being locked out of your system.'';
      }
    ] ++ flip mapAttrsToList cfg.users (name: user:
      {
        assertion = (user.hashedPassword != null)
                    -> (builtins.match ".*:.*" user.hashedPassword == null);
        message = ''
          The password hash of user "${name}" contains a ":" character.
          This is invalid and would break the login system because the fields
          of /etc/shadow (file where hashes are stored) are colon-separated.
          Please check the value of option `users.users."${name}".hashedPassword`.'';
      }
    );

    warnings =
      builtins.filter (x: x != null) (
        flip mapAttrsToList cfg.users (name: user:
        # This regex matches a subset of the Modular Crypto Format (MCF)[1]
        # informal standard. Since this depends largely on the OS or the
        # specific implementation of crypt(3) we only support the (sane)
        # schemes implemented by glibc and BSDs. In particular the original
        # DES hash is excluded since, having no structure, it would validate
        # common mistakes like typing the plaintext password.
        #
        # [1]: https://en.wikipedia.org/wiki/Crypt_(C)
        let
          sep = "\\$";
          base64 = "[a-zA-Z0-9./]+";
          id = "[a-z0-9-]+";
          value = "[a-zA-Z0-9/+.-]+";
          options = "${id}(=${value})?(,${id}=${value})*";
          scheme  = "${id}(${sep}${options})?";
          content = "${base64}${sep}${base64}";
          mcf = "^${sep}${scheme}${sep}${content}$";
        in
        if (allowsLogin user.hashedPassword
            && user.hashedPassword != ""  # login without password
            && builtins.match mcf user.hashedPassword == null)
        then ''
          The password hash of user "${name}" may be invalid. You must set a
          valid hash or the user will be locked out of their account. Please
          check the value of option `users.users."${name}".hashedPassword`.''
        else null
      ));

  };

}
