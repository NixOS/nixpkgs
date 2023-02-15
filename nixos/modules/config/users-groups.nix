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
    The options {option}`hashedPassword`,
    {option}`password` and {option}`passwordFile`
    controls what password is set for the user.
    {option}`hashedPassword` overrides both
    {option}`password` and {option}`passwordFile`.
    {option}`password` overrides {option}`passwordFile`.
    If none of these three options are set, no password is assigned to
    the user, and the user will not be able to do password logins.
    If the option {option}`users.mutableUsers` is true, the
    password defined in one of the three options will only be set when
    the user is created for the first time. After that, you are free to
    change the password with the ordinary user management commands. If
    {option}`users.mutableUsers` is false, you cannot change
    user passwords, they will always be set according to the password
    options.
  '';

  hashedPasswordDescription = ''
    To generate a hashed password run `mkpasswd`.

    If set to an empty string (`""`), this user will
    be able to log in without being asked for a password (but not via remote
    services such as SSH, or indirectly via {command}`su` or
    {command}`sudo`). This should only be used for e.g. bootable
    live systems. Note: this is different from setting an empty password,
    which can be achieved using {option}`users.users.<name?>.password`.

    If set to `null` (default) this user will not
    be able to log in using a password (i.e. via {command}`login`
    command).
  '';

  userOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = types.passwdEntry types.str;
        apply = x: assert (builtins.stringLength x < 32 || abort "Username '${x}' is longer than 31 characters which is not allowed!"); x;
        description = lib.mdDoc ''
          The name of the user account. If undefined, the name of the
          attribute set will be used.
        '';
      };

      description = mkOption {
        type = types.passwdEntry types.str;
        default = "";
        example = "Alice Q. User";
        description = lib.mdDoc ''
          A short description of the user account, typically the
          user's full name.  This is actually the “GECOS” or “comment”
          field in {file}`/etc/passwd`.
        '';
      };

      uid = mkOption {
        type = with types; nullOr int;
        default = null;
        description = lib.mdDoc ''
          The account UID. If the UID is null, a free UID is picked on
          activation.
        '';
      };

      isSystemUser = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Indicates if the user is a system user or not. This option
          only has an effect if {option}`uid` is
          {option}`null`, in which case it determines whether
          the user's UID is allocated in the range for system users
          (below 1000) or in the range for normal users (starting at
          1000).
          Exactly one of `isNormalUser` and
          `isSystemUser` must be true.
        '';
      };

      isNormalUser = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Indicates whether this is an account for a “real” user.
          This automatically sets {option}`group` to `users`,
          {option}`createHome` to `true`,
          {option}`home` to {file}`/home/«username»`,
          {option}`useDefaultShell` to `true`,
          and {option}`isSystemUser` to `false`.
          Exactly one of `isNormalUser` and `isSystemUser` must be true.
        '';
      };

      group = mkOption {
        type = types.str;
        apply = x: assert (builtins.stringLength x < 32 || abort "Group name '${x}' is longer than 31 characters which is not allowed!"); x;
        default = "";
        description = lib.mdDoc "The user's primary group.";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc "The user's auxiliary groups.";
      };

      home = mkOption {
        type = types.passwdEntry types.path;
        default = "/var/empty";
        description = lib.mdDoc "The user's home directory.";
      };

      homeMode = mkOption {
        type = types.strMatching "[0-7]{1,5}";
        default = "700";
        description = lib.mdDoc "The user's home directory mode in numeric format. See chmod(1). The mode is only applied if {option}`users.users.<name>.createHome` is true.";
      };

      cryptHomeLuks = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Path to encrypted luks device that contains
          the user's home directory.
        '';
      };

      pamMount = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = lib.mdDoc ''
          Attributes for user's entry in
          {file}`pam_mount.conf.xml`.
          Useful attributes might include `path`,
          `options`, `fstype`, and `server`.
          See <http://pam-mount.sourceforge.net/pam_mount.conf.5.html>
          for more information.
        '';
      };

      shell = mkOption {
        type = types.nullOr (types.either types.shellPackage (types.passwdEntry types.path));
        default = pkgs.shadow;
        defaultText = literalExpression "pkgs.shadow";
        example = literalExpression "pkgs.bashInteractive";
        description = lib.mdDoc ''
          The path to the user's shell. Can use shell derivations,
          like `pkgs.bashInteractive`. Don’t
          forget to enable your shell in
          `programs` if necessary,
          like `programs.zsh.enable = true;`.
        '';
      };

      subUidRanges = mkOption {
        type = with types; listOf (submodule subordinateUidRange);
        default = [];
        example = [
          { startUid = 1000; count = 1; }
          { startUid = 100001; count = 65534; }
        ];
        description = lib.mdDoc ''
          Subordinate user ids that user is allowed to use.
          They are set into {file}`/etc/subuid` and are used
          by `newuidmap` for user namespaces.
        '';
      };

      subGidRanges = mkOption {
        type = with types; listOf (submodule subordinateGidRange);
        default = [];
        example = [
          { startGid = 100; count = 1; }
          { startGid = 1001; count = 999; }
        ];
        description = lib.mdDoc ''
          Subordinate group ids that user is allowed to use.
          They are set into {file}`/etc/subgid` and are used
          by `newgidmap` for user namespaces.
        '';
      };

      autoSubUidGidRange = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = lib.mdDoc ''
          Automatically allocate subordinate user and group ids for this user.
          Allocated range is currently always of size 65536.
        '';
      };

      createHome = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to create the home directory and ensure ownership as well as
          permissions to match the user.
        '';
      };

      useDefaultShell = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If true, the user's shell will be set to
          {option}`users.defaultUserShell`.
        '';
      };

      hashedPassword = mkOption {
        type = with types; nullOr (passwdEntry str);
        default = null;
        description = lib.mdDoc ''
          Specifies the hashed password for the user.
          ${passwordDescription}
          ${hashedPasswordDescription}
        '';
      };

      password = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          The full path to a file that contains the user's password. The password
          file is read on each system activation. The file should contain
          exactly one line, which should be the password in an encrypted form
          that is suitable for the `chpasswd -e` command.
          ${passwordDescription}
        '';
      };

      initialHashedPassword = mkOption {
        type = with types; nullOr (passwdEntry str);
        default = null;
        description = lib.mdDoc ''
          Specifies the initial hashed password for the user, i.e. the
          hashed password assigned if the user does not already
          exist. If {option}`users.mutableUsers` is true, the
          password can be changed subsequently using the
          {command}`passwd` command. Otherwise, it's
          equivalent to setting the {option}`hashedPassword` option.

          ${hashedPasswordDescription}
        '';
      };

      initialPassword = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc ''
          Specifies the initial password for the user, i.e. the
          password assigned if the user does not already exist. If
          {option}`users.mutableUsers` is true, the password
          can be changed subsequently using the
          {command}`passwd` command. Otherwise, it's
          equivalent to setting the {option}`password`
          option. The same caveat applies: the password specified here
          is world-readable in the Nix store, so it should only be
          used for guest accounts or passwords that will be changed
          promptly.
        '';
      };

      packages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = literalExpression "[ pkgs.firefox pkgs.thunderbird ]";
        description = lib.mdDoc ''
          The set of packages that should be made available to the user.
          This is in contrast to {option}`environment.systemPackages`,
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
          homeMode = mkDefault "700";
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
        (mkIf (config.isNormalUser && config.subUidRanges == [] && config.subGidRanges == []) {
          autoSubUidGidRange = mkDefault true;
        })
      ];

  };

  groupOpts = { name, config, ... }: {

    options = {

      name = mkOption {
        type = types.passwdEntry types.str;
        description = lib.mdDoc ''
          The name of the group. If undefined, the name of the attribute set
          will be used.
        '';
      };

      gid = mkOption {
        type = with types; nullOr int;
        default = null;
        description = lib.mdDoc ''
          The group GID. If the GID is null, a free GID is picked on
          activation.
        '';
      };

      members = mkOption {
        type = with types; listOf (passwdEntry str);
        default = [];
        description = lib.mdDoc ''
          The user names of the group members, added to the
          `/etc/group` file.
        '';
      };

    };

    config = {
      name = mkDefault name;

      members = mapAttrsToList (n: u: u.name) (
        filterAttrs (n: u: elem config.name u.extraGroups) cfg.users
      );
    };

  };

  subordinateUidRange = {
    options = {
      startUid = mkOption {
        type = types.int;
        description = lib.mdDoc ''
          Start of the range of subordinate user ids that user is
          allowed to use.
        '';
      };
      count = mkOption {
        type = types.int;
        default = 1;
        description = lib.mdDoc "Count of subordinate user ids";
      };
    };
  };

  subordinateGidRange = {
    options = {
      startGid = mkOption {
        type = types.int;
        description = lib.mdDoc ''
          Start of the range of subordinate group ids that user is
          allowed to use.
        '';
      };
      count = mkOption {
        type = types.int;
        default = 1;
        description = lib.mdDoc "Count of subordinate group ids";
      };
    };
  };

  idsAreUnique = set: idAttr: !(foldr (name: args@{ dup, acc }:
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
          name uid group description home homeMode createHome isSystemUser
          password passwordFile hashedPassword
          autoSubUidGidRange subUidRanges subGidRanges
          initialPassword initialHashedPassword;
        shell = utils.toShellPath u.shell;
      }) cfg.users;
    groups = attrValues cfg.groups;
  });

  systemShells =
    let
      shells = mapAttrsToList (_: u: u.shell) cfg.users;
    in
      filter types.shellPackage.check shells;

in {
  imports = [
    (mkAliasOptionModuleMD [ "users" "extraUsers" ] [ "users" "users" ])
    (mkAliasOptionModuleMD [ "users" "extraGroups" ] [ "users" "groups" ])
    (mkRenamedOptionModule ["security" "initialRootPassword"] ["users" "users" "root" "initialHashedPassword"])
  ];

  ###### interface
  options = {

    users.mutableUsers = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        If set to `true`, you are free to add new users and groups to the system
        with the ordinary `useradd` and
        `groupadd` commands. On system activation, the
        existing contents of the `/etc/passwd` and
        `/etc/group` files will be merged with the
        contents generated from the `users.users` and
        `users.groups` options.
        The initial password for a user will be set
        according to `users.users`, but existing passwords
        will not be changed.

        ::: {.warning}
        If set to `false`, the contents of the user and
        group files will simply be replaced on system activation. This also
        holds for the user passwords; all changed
        passwords will be reset according to the
        `users.users` configuration on activation.
        :::
      '';
    };

    users.enforceIdUniqueness = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
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
      description = lib.mdDoc ''
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
      description = lib.mdDoc ''
        Additional groups to be created automatically by the system.
      '';
    };


    users.allowNoPasswordLogin = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Disable checking that at least the `root` user or a user in the `wheel` group can log in using
        a password or an SSH key.

        WARNING: enabling this can lock you out of your system. Enable this only if you know what are you doing.
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
        initialHashedPassword = mkDefault "!";
      };
      nobody = {
        uid = ids.uids.nobody;
        isSystemUser = true;
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
      sgx.gid = ids.gids.sgx;
      shadow.gid = ids.gids.shadow;
    };

    system.activationScripts.users = {
      supportsDryActivation = true;
      text = ''
        install -m 0700 -d /root
        install -m 0755 -d /home

        ${pkgs.perl.withPackages (p: [ p.FileSlurp p.JSON ])}/bin/perl \
        -w ${./update-users-groups.pl} ${spec}
      '';
    };

    # Warn about user accounts with deprecated password hashing schemes
    system.activationScripts.hashes = {
      deps = [ "users" ];
      text = ''
        users=()
        while IFS=: read -r user hash tail; do
          if [[ "$hash" = "$"* && ! "$hash" =~ ^\$(y|gy|7|2b|2y|2a|6)\$ ]]; then
            users+=("$user")
          fi
        done </etc/shadow

        if (( "''${#users[@]}" )); then
          echo "
        WARNING: The following user accounts rely on password hashes that will
        be removed in NixOS 23.05. They should be renewed as soon as possible."
          printf ' - %s\n' "''${users[@]}"
        fi
      '';
    };

    # for backwards compatibility
    system.activationScripts.groups = stringAfter [ "users" ] "";

    # Install all the user shells
    environment.systemPackages = systemShells;

    environment.etc = mapAttrs' (_: { packages, name, ... }: {
      name = "profiles/per-user/${name}";
      value.source = pkgs.buildEnv {
        name = "user-environment";
        paths = packages;
        inherit (config.environment) pathsToLink extraOutputsToInstall;
        inherit (config.system.path) ignoreCollisions postBuild;
      };
    }) (filterAttrs (_: u: u.packages != []) cfg.users);

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
        # The check does not apply when users.disableLoginPossibilityAssertion
        # The check does not apply when users.mutableUsers
        assertion = !cfg.mutableUsers -> !cfg.allowNoPasswordLogin ->
          any id (mapAttrsToList (name: cfg:
            (name == "root"
             || cfg.group == "wheel"
             || elem "wheel" cfg.extraGroups)
            &&
            (allowsLogin cfg.hashedPassword
             || cfg.password != null
             || cfg.passwordFile != null
             || cfg.openssh.authorizedKeys.keys != []
             || cfg.openssh.authorizedKeys.keyFiles != [])
          ) cfg.users ++ [
            config.security.googleOsLogin.enable
          ]);
        message = ''
          Neither the root account nor any wheel user has a password or SSH authorized key.
          You must set one to prevent being locked out of your system.
          If you really want to be locked out of your system, set users.allowNoPasswordLogin = true;
          However you are most probably better off by setting users.mutableUsers = true; and
          manually running passwd root to set the root password.
          '';
      }
    ] ++ flatten (flip mapAttrsToList cfg.users (name: user:
      [
        {
        assertion = (user.hashedPassword != null)
        -> (builtins.match ".*:.*" user.hashedPassword == null);
        message = ''
            The password hash of user "${user.name}" contains a ":" character.
            This is invalid and would break the login system because the fields
            of /etc/shadow (file where hashes are stored) are colon-separated.
            Please check the value of option `users.users."${user.name}".hashedPassword`.'';
          }
          {
            assertion = let
              xor = a: b: a && !b || b && !a;
              isEffectivelySystemUser = user.isSystemUser || (user.uid != null && user.uid < 1000);
            in xor isEffectivelySystemUser user.isNormalUser;
            message = ''
              Exactly one of users.users.${user.name}.isSystemUser and users.users.${user.name}.isNormalUser must be set.
            '';
          }
          {
            assertion = user.group != "";
            message = ''
              users.users.${user.name}.group is unset. This used to default to
              nogroup, but this is unsafe. For example you can create a group
              for this user with:
              users.users.${user.name}.group = "${user.name}";
              users.groups.${user.name} = {};
            '';
          }
        ]
    ));

    warnings =
      builtins.filter (x: x != null) (
        flip mapAttrsToList cfg.users (_: user:
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
          content = "${base64}${sep}${base64}(${sep}${base64})?";
          mcf = "^${sep}${scheme}${sep}${content}$";
        in
        if (allowsLogin user.hashedPassword
            && user.hashedPassword != ""  # login without password
            && builtins.match mcf user.hashedPassword == null)
        then ''
          The password hash of user "${user.name}" may be invalid. You must set a
          valid hash or the user will be locked out of their account. Please
          check the value of option `users.users."${user.name}".hashedPassword`.''
        else null
      ));

  };

}
