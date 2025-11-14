{
  config,
  lib,
  utils,
  pkgs,
  ...
}:

let
  inherit (lib)
    any
    attrNames
    attrValues
    boolToString
    concatMap
    concatMapStringsSep
    concatStrings
    elem
    filter
    filterAttrs
    flatten
    flip
    foldr
    generators
    getAttr
    hasAttr
    id
    length
    listToAttrs
    literalExpression
    mapAttrs'
    mapAttrsToList
    match
    mkAliasOptionModule
    mkDefault
    mkIf
    mkMerge
    mkOption
    mkRenamedOptionModule
    optional
    optionals
    sort
    stringAfter
    stringLength
    trace
    types
    versionOlder
    xor
    ;

  ids = config.ids;
  cfg = config.users;

  # Check whether a password hash will allow login.
  allowsLogin =
    hash:
    hash == "" # login without password
    || !(lib.elem hash [
      null # password login disabled
      "!" # password login disabled
      "!!" # a variant of "!"
      "*" # password unset
    ]);

  overrideOrderMutable = ''{option}`initialHashedPassword` -> {option}`initialPassword` -> {option}`hashedPassword` -> {option}`password` -> {option}`hashedPasswordFile`'';

  overrideOrderImmutable = ''{option}`initialHashedPassword` -> {option}`hashedPassword` -> {option}`initialPassword` -> {option}`password` -> {option}`hashedPasswordFile`'';

  overrideOrderText = isMutable: ''
    If the option {option}`users.mutableUsers` is
    `${if isMutable then "true" else "false"}`, then the order of precedence is as shown
    below, where values on the left are overridden by values on the right:
    ${if isMutable then overrideOrderMutable else overrideOrderImmutable}
  '';

  multiplePasswordsWarning = ''
    If multiple of these password options are set at the same time then a
    specific order of precedence is followed, which can lead to surprising
    results. The order of precedence differs depending on whether the
    {option}`users.mutableUsers` option is set.
  '';

  overrideDescription = ''
    ${multiplePasswordsWarning}

    ${overrideOrderText false}

    ${overrideOrderText true}
  '';

  passwordDescription = ''
    The {option}`initialHashedPassword`, {option}`hashedPassword`,
    {option}`initialPassword`, {option}`password` and
    {option}`hashedPasswordFile` options all control what password is set for
    the user.

    In a system where [](#opt-systemd.sysusers.enable) is `false`, typically
    only one of {option}`hashedPassword`, {option}`password`, or
    {option}`hashedPasswordFile` will be set.

    In a system where [](#opt-systemd.sysusers.enable) or [](#opt-services.userborn.enable) is `true`,
    typically only one of {option}`initialPassword`, {option}`initialHashedPassword`,
    or {option}`hashedPasswordFile` will be set.

    If the option {option}`users.mutableUsers` is true, the password defined
    in one of the above password options will only be set when the user is
    created for the first time. After that, you are free to change the
    password with the ordinary user management commands. If
    {option}`users.mutableUsers` is false, you cannot change user passwords,
    they will always be set according to the password options.

    If none of the password options are set, then no password is assigned to
    the user, and the user will not be able to do password-based logins.

    ${overrideDescription}
  '';

  hashedPasswordDescription = ''
    To generate a hashed password run `mkpasswd`.

    If set to an empty string (`""`), this user will be able to log in without
    being asked for a password (but not via remote services such as SSH, or
    indirectly via {command}`su` or {command}`sudo`). This should only be used
    for e.g. bootable live systems. Note: this is different from setting an
    empty password, which can be achieved using
    {option}`users.users.<name?>.password`.

    If set to `null` (default) this user will not be able to log in using a
    password (i.e. via {command}`login` command).
  '';

  userOpts =
    { name, config, ... }:
    {

      options = {

        enable = mkOption {
          type = types.bool;
          default = true;
          example = false;
          description = ''
            If set to false, the user account will not be created. This is useful for when you wish to conditionally
            disable user accounts.
          '';
        };

        name = mkOption {
          type = types.passwdEntry types.str;
          apply =
            x:
            assert (
              stringLength x < 32 || abort "Username '${x}' is longer than 31 characters which is not allowed!"
            );
            x;
          description = ''
            The name of the user account. If undefined, the name of the
            attribute set will be used.
          '';
        };

        description = mkOption {
          type = types.passwdEntry types.str;
          default = "";
          example = "Alice Q. User";
          description = ''
            A short description of the user account, typically the
            user's full name.  This is actually the “GECOS” or “comment”
            field in {file}`/etc/passwd`.
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
          description = ''
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
          apply =
            x:
            assert (
              stringLength x < 32 || abort "Group name '${x}' is longer than 31 characters which is not allowed!"
            );
            x;
          default = "";
          description = "The user's primary group.";
        };

        extraGroups = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "The user's auxiliary groups.";
        };

        home = mkOption {
          type = types.passwdEntry types.path;
          default = "/var/empty";
          description = "The user's home directory.";
        };

        homeMode = mkOption {
          type = types.strMatching "[0-7]{1,5}";
          default = "700";
          description = "The user's home directory mode in numeric format. See {manpage}`chmod(1)`. The mode is only applied if {option}`users.users.<name>.createHome` is true.";
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
          default = { };
          description = ''
            Attributes for user's entry in
            {file}`pam_mount.conf.xml`.
            Useful attributes might include `path`,
            `options`, `fstype`, and `server`.
            See <https://pam-mount.sourceforge.net/pam_mount.conf.5.html>
            for more information.
          '';
        };

        shell = mkOption {
          type = types.nullOr (types.either types.shellPackage (types.passwdEntry types.path));
          default = pkgs.shadow;
          defaultText = literalExpression "pkgs.shadow";
          example = literalExpression "pkgs.bashInteractive";
          description = ''
            The path to the user's shell. Can use shell derivations,
            like `pkgs.bashInteractive`. Don’t
            forget to enable your shell in
            `programs` if necessary,
            like `programs.zsh.enable = true;`.
          '';
        };

        ignoreShellProgramCheck = mkOption {
          type = types.bool;
          default = false;
          description = ''
            By default, nixos will check that programs.SHELL.enable is set to
            true if the user has a custom shell specified. If that behavior isn't
            required and there are custom overrides in place to make sure that the
            shell is functional, set this to true.
          '';
        };

        subUidRanges = mkOption {
          type = with types; listOf (submodule subordinateUidRange);
          default = [ ];
          example = [
            {
              startUid = 1000;
              count = 1;
            }
            {
              startUid = 100001;
              count = 65534;
            }
          ];
          description = ''
            Subordinate user ids that user is allowed to use.
            They are set into {file}`/etc/subuid` and are used
            by `newuidmap` for user namespaces.
          '';
        };

        subGidRanges = mkOption {
          type = with types; listOf (submodule subordinateGidRange);
          default = [ ];
          example = [
            {
              startGid = 100;
              count = 1;
            }
            {
              startGid = 1001;
              count = 999;
            }
          ];
          description = ''
            Subordinate group ids that user is allowed to use.
            They are set into {file}`/etc/subgid` and are used
            by `newgidmap` for user namespaces.
          '';
        };

        autoSubUidGidRange = mkOption {
          type = types.bool;
          default = false;
          example = true;
          description = ''
            Automatically allocate subordinate user and group ids for this user.
            Allocated range is currently always of size 65536.
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
            {option}`users.defaultUserShell`.
          '';
        };

        hashedPassword = mkOption {
          type = with types; nullOr (passwdEntry str);
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

        hashedPasswordFile = mkOption {
          type = with types; nullOr str;
          default = config.passwordFile;
          defaultText = literalExpression "null";
          description = ''
            The full path to a file that contains the hash of the user's
            password. The password file is read on each system activation. The
            file should contain exactly one line, which should be the password in
            an encrypted form that is suitable for the `chpasswd -e` command.

            ${passwordDescription}
          '';
        };

        passwordFile = mkOption {
          type = with types; nullOr str;
          default = null;
          visible = false;
          description = "Deprecated alias of hashedPasswordFile";
        };

        initialHashedPassword = mkOption {
          type = with types; nullOr (passwdEntry str);
          default = null;
          description = ''
            Specifies the initial hashed password for the user, i.e. the
            hashed password assigned if the user does not already
            exist. If {option}`users.mutableUsers` is true, the
            password can be changed subsequently using the
            {command}`passwd` command. Otherwise, it's
            equivalent to setting the {option}`hashedPassword` option.

            ${passwordDescription}
            ${hashedPasswordDescription}
          '';
        };

        initialPassword = mkOption {
          type = with types; nullOr str;
          default = null;
          description = ''
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

            ${passwordDescription}
          '';
        };

        packages = mkOption {
          type = types.listOf types.package;
          default = [ ];
          example = literalExpression "[ pkgs.firefox pkgs.thunderbird ]";
          description = ''
            The set of packages that should be made available to the user.
            This is in contrast to {option}`environment.systemPackages`,
            which adds packages to all users.
          '';
        };

        expires = mkOption {
          type = types.nullOr (types.strMatching "[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}");
          default = null;
          description = ''
            Set the date on which the user's account will no longer be
            accessible. The date is expressed in the format YYYY-MM-DD, or null
            to disable the expiry.
            A user whose account is locked must contact the system
            administrator before being able to use the system again.
          '';
        };

        linger = mkOption {
          type = types.nullOr types.bool;
          example = true;
          default = null;
          description = ''
            Whether to enable or disable lingering for this user.  Without
            lingering, user units will not be started until the user logs in,
            and may be stopped on logout depending on the settings in
            `logind.conf`.

            By default, NixOS will not manage lingering, new users will default
            to not lingering, and lingering can be configured imperatively using
            `loginctl enable-linger` or `loginctl disable-linger`. Setting
            this option to `true` or `false` is the declarative equivalent of
            running `loginctl enable-linger` or `loginctl disable-linger`
            respectively.
          '';
        };
      };

      config = mkMerge [
        {
          name = mkDefault name;
          shell = mkIf config.useDefaultShell (mkDefault cfg.defaultUserShell);
        }
        (mkIf config.isNormalUser {
          group = mkDefault "users";
          createHome = mkDefault true;
          home = mkDefault "${cfg.defaultUserHome}/${config.name}";
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
        (mkIf (config.isNormalUser && config.subUidRanges == [ ] && config.subGidRanges == [ ]) {
          autoSubUidGidRange = mkDefault true;
        })
      ];

    };

  groupOpts =
    { name, config, ... }:
    {

      options = {

        name = mkOption {
          type = types.passwdEntry types.str;
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
          type = with types; listOf (passwdEntry str);
          default = [ ];
          description = ''
            The user names of the group members, added to the
            `/etc/group` file.
          '';
        };

      };

      config = {
        name = mkDefault name;

        members = mapAttrsToList (n: u: u.name) (
          filterAttrs (n: u: u.enable && elem config.name u.extraGroups) cfg.users
        );
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
        description = "Count of subordinate user ids";
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
        description = "Count of subordinate group ids";
      };
    };
  };

  idsAreUnique =
    set: idAttr:
    !(foldr
      (
        name:
        args@{ dup, acc }:
        let
          id = toString (getAttr idAttr (getAttr name set));
          exists = hasAttr id acc;
          newAcc =
            acc
            // (listToAttrs [
              {
                name = id;
                value = true;
              }
            ]);
        in
        if dup then
          args
        else if exists then
          trace "Duplicate ${idAttr} ${id}" {
            dup = true;
            acc = null;
          }
        else
          {
            dup = false;
            acc = newAcc;
          }
      )
      {
        dup = false;
        acc = { };
      }
      (attrNames set)
    ).dup;

  uidsAreUnique = idsAreUnique (filterAttrs (n: u: u.uid != null) cfg.users) "uid";
  gidsAreUnique = idsAreUnique (filterAttrs (n: g: g.gid != null) cfg.groups) "gid";
  sdInitrdUidsAreUnique = idsAreUnique (filterAttrs (
    n: u: u.uid != null
  ) config.boot.initrd.systemd.users) "uid";
  sdInitrdGidsAreUnique = idsAreUnique (filterAttrs (
    n: g: g.gid != null
  ) config.boot.initrd.systemd.groups) "gid";
  groupNames = lib.mapAttrsToList (n: g: g.name) cfg.groups;
  usersWithoutExistingGroup = lib.filterAttrs (
    n: u: u.group != "" && !lib.elem u.group groupNames
  ) cfg.users;
  usersWithNullShells = attrNames (filterAttrs (name: cfg: cfg.shell == null) cfg.users);

  spec = pkgs.writeText "users-groups.json" (
    builtins.toJSON {
      inherit (cfg) mutableUsers;
      users = mapAttrsToList (_: u: {
        inherit (u)
          name
          uid
          group
          description
          home
          homeMode
          createHome
          isSystemUser
          password
          hashedPasswordFile
          hashedPassword
          autoSubUidGidRange
          subUidRanges
          subGidRanges
          initialPassword
          initialHashedPassword
          expires
          ;
        shell = utils.toShellPath u.shell;
      }) (filterAttrs (_: u: u.enable) cfg.users);
      groups = attrValues cfg.groups;
    }
  );

  systemShells =
    let
      shells = mapAttrsToList (_: u: u.shell) cfg.users;
    in
    filter types.shellPackage.check shells;
in
{
  imports = [
    (mkAliasOptionModule [ "users" "extraUsers" ] [ "users" "users" ])
    (mkAliasOptionModule [ "users" "extraGroups" ] [ "users" "groups" ])
    (mkRenamedOptionModule
      [ "security" "initialRootPassword" ]
      [ "users" "users" "root" "initialHashedPassword" ]
    )
  ];

  ###### interface
  options = {

    users.mutableUsers = mkOption {
      type = types.bool;
      default = true;
      description = ''
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
      description = ''
        Whether to require that no two users/groups share the same uid/gid.
      '';
    };

    users.manageLingering = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to manage whether users linger or not.";
      example = false;
    };

    users.users = mkOption {
      default = { };
      type = with types; attrsOf (submodule userOpts);
      example = {
        alice = {
          uid = 1234;
          description = "Alice Q. User";
          home = "/home/alice";
          createHome = true;
          group = "users";
          extraGroups = [ "wheel" ];
          shell = "/bin/sh";
        };
      };
      description = ''
        Additional user accounts to be created automatically by the system.
        This can also be used to set options for root.
      '';
    };

    users.groups = mkOption {
      default = { };
      example = {
        students.gid = 1001;
        hackers = { };
      };
      type = with types; attrsOf (submodule groupOpts);
      description = ''
        Additional groups to be created automatically by the system.
      '';
    };

    users.allowNoPasswordLogin = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable checking that at least the `root` user or a user in the `wheel` group can log in using
        a password or an SSH key.

        WARNING: enabling this can lock you out of your system. Enable this only if you know what are you doing.
      '';
    };

    users.defaultUserHome = mkOption {
      type = types.str;
      default = "/home";
      description = ''
        The default home directory for normal users.
      '';
    };

    # systemd initrd
    boot.initrd.systemd.users = mkOption {
      description = ''
        Users to include in initrd.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options.uid = mkOption {
              type = types.int;
              description = ''
                ID of the user in initrd.
              '';
              defaultText = literalExpression "config.users.users.\${name}.uid";
              default = cfg.users.${name}.uid;
            };
            options.group = mkOption {
              type = types.singleLineStr;
              description = ''
                Group the user belongs to in initrd.
              '';
              defaultText = literalExpression "config.users.users.\${name}.group";
              default = cfg.users.${name}.group;
            };
            options.shell = mkOption {
              type = types.passwdEntry types.path;
              description = ''
                The path to the user's shell in initrd.
              '';
              default = "${pkgs.shadow}/bin/nologin";
              defaultText = literalExpression "\${pkgs.shadow}/bin/nologin";
            };
          }
        )
      );
    };

    boot.initrd.systemd.groups = mkOption {
      description = ''
        Groups to include in initrd.
      '';
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options.gid = mkOption {
              type = types.int;
              description = ''
                ID of the group in initrd.
              '';
              defaultText = literalExpression "config.users.groups.\${name}.gid";
              default = cfg.groups.${name}.gid;
            };
          }
        )
      );
    };
  };

  ###### implementation

  config =
    let
      cryptSchemeIdPatternGroup = "(${lib.concatStringsSep "|" pkgs.libxcrypt.enabledCryptSchemeIds})";
    in
    {

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
        clock.gid = ids.gids.clock;
      };

      system.activationScripts.users =
        if !config.systemd.sysusers.enable && !config.services.userborn.enable then
          {
            supportsDryActivation = true;
            text = ''
              install -m 0700 -d /root
              install -m 0755 -d /home

              ${
                pkgs.perl.withPackages (p: [
                  p.FileSlurp
                  p.JSON
                ])
              }/bin/perl \
              -w ${./update-users-groups.pl} ${spec}
            '';
          }
        else
          ""; # keep around for backwards compatibility

      systemd.services.linger-users = lib.mkIf cfg.manageLingering {
        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-logind.service" ];
        requires = [ "systemd-logind.service" ];

        script =
          let
            lingeringUsers = filterAttrs (n: v: v.linger == true) cfg.users;
            nonLingeringUsers = filterAttrs (n: v: v.linger == false) cfg.users;
            lingeringUserNames = mapAttrsToList (n: v: v.name) lingeringUsers;
            nonLingeringUserNames = mapAttrsToList (n: v: v.name) nonLingeringUsers;
          in
          ''
            ${lib.strings.toShellVars { inherit lingeringUserNames nonLingeringUserNames; }}

            user_configured () {
                # Use `id` to check if the user exists rather than checking the
                # NixOS configuration, as it may be that the user has been
                # manually configured, which is permitted if users.mutableUsers
                # is true (the default).
                id "$1" >/dev/null
            }

            shopt -s dotglob nullglob
            for user in *; do
                if ! user_configured "$user"; then
                    # systemd has this user configured to linger despite them not
                    # existing.
                    echo "Removing linger for missing user $user" >&2
                    rm -- "$user"
                fi
            done

            if (( ''${#nonLingeringUserNames[*]} > 0 )); then
                ${config.systemd.package}/bin/loginctl disable-linger "''${nonLingeringUserNames[@]}"
            fi
            if (( ''${#lingeringUserNames[*]} > 0 )); then
                ${config.systemd.package}/bin/loginctl enable-linger "''${lingeringUserNames[@]}"
            fi
          '';

        serviceConfig = {
          Type = "oneshot";
          StateDirectory = "systemd/linger";
          WorkingDirectory = "/var/lib/systemd/linger";
        };
      };

      # Warn about user accounts with deprecated password hashing schemes
      # This does not work when the users and groups are created by
      # systemd-sysusers because the users are created too late then.
      system.activationScripts.hashes =
        if !config.systemd.sysusers.enable && !config.services.userborn.enable then
          {
            deps = [ "users" ];
            text = ''
              users=()
              while IFS=: read -r user hash _; do
                if [[ "$hash" = "$"* && ! "$hash" =~ ^\''$${cryptSchemeIdPatternGroup}\$ ]]; then
                  users+=("$user")
                fi
              done </etc/shadow

              if (( "''${#users[@]}" )); then
                echo "
              WARNING: The following user accounts rely on password hashing algorithms
              that have been removed. They need to be renewed as soon as possible, as
              they do prevent their users from logging in."
                printf ' - %s\n' "''${users[@]}"
              fi
            '';
          }
        else
          ""; # keep around for backwards compatibility

      # for backwards compatibility
      system.activationScripts.groups = stringAfter [ "users" ] "";

      # Install all the user shells
      environment.systemPackages = systemShells;

      environment.etc = mapAttrs' (
        _:
        { packages, name, ... }:
        {
          name = "profiles/per-user/${name}";
          value.source = pkgs.buildEnv {
            name = "user-environment";
            paths = packages;
            inherit (config.environment) pathsToLink extraOutputsToInstall;
            inherit (config.system.path) ignoreCollisions postBuild;
          };
        }
      ) (filterAttrs (_: u: u.packages != [ ]) cfg.users);

      environment.profiles = [
        "$HOME/.nix-profile"
        "\${XDG_STATE_HOME}/nix/profile"
        "$HOME/.local/state/nix/profile"
        "/etc/profiles/per-user/$USER"
      ];

      # systemd initrd
      boot.initrd.systemd = lib.mkIf config.boot.initrd.systemd.enable {
        contents = {
          "/etc/passwd".text = ''
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (
                n:
                {
                  uid,
                  group,
                  shell,
                }:
                let
                  g = config.boot.initrd.systemd.groups.${group};
                in
                "${n}:x:${toString uid}:${toString g.gid}::/var/empty:${shell}"
              ) config.boot.initrd.systemd.users
            )}
          '';
          "/etc/group".text = ''
            ${lib.concatStringsSep "\n" (
              lib.mapAttrsToList (n: { gid }: "${n}:x:${toString gid}:") config.boot.initrd.systemd.groups
            )}
          '';
          "/etc/shells".text =
            lib.concatStringsSep "\n" (
              lib.unique (lib.mapAttrsToList (_: u: u.shell) config.boot.initrd.systemd.users)
            )
            + "\n";
        };

        storePaths = [ "${pkgs.shadow}/bin/nologin" ];

        users = {
          root = {
            shell = lib.mkDefault "/bin/bash";
          };
          nobody = { };
        };

        groups = {
          root = { };
          nogroup = { };
          systemd-journal = { };
          tty = { };
          dialout = { };
          kmem = { };
          input = { };
          video = { };
          render = { };
          sgx = { };
          audio = { };
          video = { };
          lp = { };
          disk = { };
          cdrom = { };
          tape = { };
          kvm = { };
          clock = { };
        };
      };

      assertions = [
        {
          assertion = !cfg.enforceIdUniqueness || (uidsAreUnique && gidsAreUnique);
          message = "UIDs and GIDs must be unique!";
        }
        {
          assertion = !cfg.enforceIdUniqueness || (sdInitrdUidsAreUnique && sdInitrdGidsAreUnique);
          message = "systemd initrd UIDs and GIDs must be unique!";
        }
        {
          assertion = usersWithoutExistingGroup == { };
          message =
            let
              errUsers = lib.attrNames usersWithoutExistingGroup;
              missingGroups = lib.unique (lib.mapAttrsToList (n: u: u.group) usersWithoutExistingGroup);
              mkConfigHint = group: "users.groups.${group} = {};";
            in
            ''
              The following users have a primary group that is undefined: ${lib.concatStringsSep " " errUsers}
              Hint: Add this to your NixOS configuration:
                ${lib.concatStringsSep "\n  " (map mkConfigHint missingGroups)}
            '';
        }
        {
          assertion = !cfg.mutableUsers -> length usersWithNullShells == 0;
          message = ''
            users.mutableUsers = false has been set,
            but found users that have their shell set to null.
            If you wish to disable login, set their shell to pkgs.shadow (the default).
            Misconfigured users: ${lib.concatStringsSep " " usersWithNullShells}
          '';
        }
        {
          # If mutableUsers is false, to prevent users creating a
          # configuration that locks them out of the system, ensure that
          # there is at least one "privileged" account that has a
          # password or an SSH authorized key. Privileged accounts are
          # root and users in the wheel group.
          # The check does not apply when users.allowNoPasswordLogin
          # The check does not apply when users.mutableUsers
          assertion =
            !cfg.mutableUsers
            -> !cfg.allowNoPasswordLogin
            -> any id (
              mapAttrsToList (
                name: cfg:
                (name == "root" || cfg.group == "wheel" || elem "wheel" cfg.extraGroups)
                && (
                  allowsLogin cfg.hashedPassword
                  || cfg.password != null
                  || cfg.hashedPasswordFile != null
                  || cfg.openssh.authorizedKeys.keys != [ ]
                  || cfg.openssh.authorizedKeys.keyFiles != [ ]
                )
              ) cfg.users
              ++ [
                config.security.googleOsLogin.enable
              ]
            );
          message = ''
            Neither the root account nor any wheel user has a password or SSH authorized key.
            You must set one to prevent being locked out of your system.
            If you really want to be locked out of your system, set users.allowNoPasswordLogin = true;
            However you are most probably better off by setting users.mutableUsers = true; and
            manually running passwd root to set the root password.
          '';
        }
      ]
      ++ flatten (
        flip mapAttrsToList cfg.users (
          name: user:
          [
            (
              let
                # Things fail in various ways with especially non-ascii usernames.
                # This regex mirrors the one from shadow's is_valid_name:
                # https://github.com/shadow-maint/shadow/blob/bee77ffc291dfed2a133496db465eaa55e2b0fec/lib/chkname.c#L68
                # though without the trailing $, because Samba 3 got its last release
                # over 10 years ago and is not in Nixpkgs anymore,
                # while later versions don't appear to require anything like that.
                nameRegex = "[a-zA-Z0-9_.][a-zA-Z0-9_.-]*";
              in
              {
                assertion = builtins.match nameRegex user.name != null;
                message = "The username \"${user.name}\" is not valid, it does not match the regex \"${nameRegex}\".";
              }
            )
            {
              assertion = (user.hashedPassword != null) -> (match ".*:.*" user.hashedPassword == null);
              message = ''
                The password hash of user "${user.name}" contains a ":" character.
                This is invalid and would break the login system because the fields
                of /etc/shadow (file where hashes are stored) are colon-separated.
                Please check the value of option `users.users."${user.name}".hashedPassword`.'';
            }
            {
              assertion = user.isNormalUser && user.uid != null -> user.uid >= 1000;
              message = ''
                A user cannot have a users.users.${user.name}.uid set below 1000 and set users.users.${user.name}.isNormalUser.
                Either users.users.${user.name}.isSystemUser must be set to true instead of users.users.${user.name}.isNormalUser
                or users.users.${user.name}.uid must be changed to 1000 or above.
              '';
            }
            {
              assertion =
                let
                  # we do an extra check on isNormalUser here, to not trigger this assertion when isNormalUser is set and uid to < 1000
                  isEffectivelySystemUser =
                    user.isSystemUser || (user.uid != null && user.uid < 1000 && !user.isNormalUser);
                in
                xor isEffectivelySystemUser user.isNormalUser;
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
            {
              assertion = user.linger != null -> cfg.manageLingering;
              message = ''
                users.manageLingering is set to false, but
                users.users.${user.name}.linger is configured.

                If you want NixOS to manage whether user accounts linger or
                not, you must set users.manageLingering to true.  This is the
                default setting.

                If you do not want NixOS to manage whether user accounts linger
                or not, you must set users.users.${user.name}.linger to null.
                This is the default setting provided system.stateVersion is at
                least "25.11".
              '';
            }
          ]
          ++ (map
            (shell: {
              assertion =
                !user.ignoreShellProgramCheck
                -> (user.shell == pkgs.${shell})
                -> (config.programs.${shell}.enable == true);
              message = ''
                users.users.${user.name}.shell is set to ${shell}, but
                programs.${shell}.enable is not true. This will cause the ${shell}
                shell to lack the basic nix directories in its PATH and might make
                logging in as that user impossible. You can fix it with:
                programs.${shell}.enable = true;

                If you know what you're doing and you are fine with the behavior,
                set users.users.${user.name}.ignoreShellProgramCheck = true;
                instead.
              '';
            })
            [
              "fish"
              "xonsh"
              "zsh"
            ]
          )
        )
      );

      warnings =
        flip concatMap (attrValues cfg.users) (
          user:
          let
            passwordOptions = [
              "hashedPassword"
              "hashedPasswordFile"
              "password"
            ]
            ++ optionals cfg.mutableUsers [
              # For immutable users, initialHashedPassword is set to hashedPassword,
              # so using these options would always trigger the assertion.
              "initialHashedPassword"
              "initialPassword"
            ];
            unambiguousPasswordConfiguration =
              1 >= length (filter (x: x != null) (map (flip getAttr user) passwordOptions));
          in
          optional (!unambiguousPasswordConfiguration) ''
            The user '${user.name}' has multiple of the options
            `initialHashedPassword`, `hashedPassword`, `initialPassword`, `password`
            & `hashedPasswordFile` set to a non-null value.

            ${multiplePasswordsWarning}
            ${overrideOrderText cfg.mutableUsers}
            The values of these options are:
            ${concatMapStringsSep "\n" (
              value: "* users.users.\"${user.name}\".${value}: ${generators.toPretty { } user.${value}}"
            ) passwordOptions}
          ''
        )
        ++ filter (x: x != null) (
          flip mapAttrsToList cfg.users (
            _: user:
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
              id = cryptSchemeIdPatternGroup;
              name = "[a-z0-9-]+";
              value = "[a-zA-Z0-9/+.-]+";
              options = "${name}(=${value})?(,${name}=${value})*";
              scheme = "${id}(${sep}${options})?";
              content = "${base64}${sep}${base64}(${sep}${base64})?";
              mcf = "^${sep}${scheme}${sep}${content}$";
            in
            if
              (
                allowsLogin user.hashedPassword
                && user.hashedPassword != "" # login without password
                && match mcf user.hashedPassword == null
              )
            then
              ''
                The password hash of user "${user.name}" may be invalid. You must set a
                valid hash or the user will be locked out of their account. Please
                check the value of option `users.users."${user.name}".hashedPassword`.''
            else
              null
          )
          ++ flip mapAttrsToList cfg.users (
            name: user:
            if user.passwordFile != null then
              ''The option `users.users."${name}".passwordFile' has been renamed ''
              + ''to `users.users."${name}".hashedPasswordFile'.''
            else
              null
          )
        );
    };

}
