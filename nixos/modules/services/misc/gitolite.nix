{ config, lib, pkgs, ... }:

# usage of unmutable repos:
#
# ex: we want a repo named testrepo where the user testuser has read and write permissions.
#
# services.gitolite = {
#   mutable = false;
#   keys = {
#     testuser = "ssh-rsa AAAA...== testuser@somepc";f
#   };
#   repos = {
#     testrepo = {
#       testuser = "RW";
#     };
#   };
# }
#

with lib;


let
  cfg = config.services.gitolite;

  adminPubkey = either2text "gitolite-admin.pub" cfg.adminPubkey;

  writeGitoliteRc =
    copyFile (either2text "gitolite.rc" cfg.rc) ".gitolite.rc" ;

  writeKey = user:
    let
      key = (getAttr user cfg.keys);
      keyFile = either2text "${user}.pub" key;

    in copyFile keyFile ".gitolite/keydir/${user}.pub" ;

  writeCommonHooks = name:
    let
      hook = (getAttr name cfg.commonHooks);
      hookFile = either2script name hook;

    in linkFile hookFile ".gitolite/hooks/common/${name}";

  copyRepoSpecificHooks = name:
    let
      hook = (getAttr name cfg.repoSpecificHooks);
      hookFile = either2script name hook;

    in linkFile hookFile ".gitolite/hooks/repo-specific/${name}";

  writeCustomFile = customFile:
    let
      basename = last (splitString "/" customFile.path);
    in linkFile (either2text basename customFile.file) customFile.path;

  createGitoliteConfig =
    linkFile (pkgs.writeText "gitolite.conf" (writeRepos cfg.repos)) ".gitolite/conf/gitolite.conf";

  either2text = label: e:
    if (isString e) then
      pkgs.writeText label e
    else
      e;

  either2script = label: e:
    if (isString e) then
      pkgs.writeScript label e
    else
      e;

  copyFile = source: target:
    ''
      rm -f ${escapeShellArg target}
      cp -f ${escapeShellArg source} ${escapeShellArg target}
    '';

  linkFile = source: target:
    ''
      ln -snf ${escapeShellArg source} ${escapeShellArg target}
    '';

  writeRepos = repos:
    let
      writeRepo = repoName:
        let
          repo = getAttr repoName cfg.repos;

          writeUserSection = users:
            concatStringsSep "\n" (map writeUser (attrNames users));

          writeUser = userName:
            "  ${getAttr userName repo.users} = ${userName}";

        in concatStringsSep "\n" [
          "repo ${repoName}"
          (writeUserSection (repo.users))
          (optionalString (repo.extraConfig != null) "  ${repo.extraConfig}")
          ""
        ];


    in concatStringsSep "\n" (map writeRepo (attrNames repos));

in
{
  options = {
    services.gitolite = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable gitolite management under the
          <literal>gitolite</literal> user. After
          switching to a configuration with Gitolite enabled, you can
          then run <literal>git clone
          gitolite@host:gitolite-admin.git</literal> to manage it further.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/gitolite";
        description = ''
          Gitolite home directory (used to store all the repositories and configuration).
        '';
      };

      adminPubkey = mkOption {
        type = with types; nullOr (either path str);
        description = ''
          Initial administrative public key for Gitolite. This should
          be an SSH Public Key. Note that this key will only be used
          once, upon the first initialization of the Gitolite user.
          The key string cannot have any line breaks in it.
        '';
      };

      commonHooks = mkOption {
        type = with types; nullOr (attrsOf (either path str));
        description = ''
          An Attributeset of hooks which get copied to <literal>~/.gitolite/hooks/common</literal>.
        '';
        default = null;
      };

      repoSpecificHooks = mkOption {
        type = with types; nullOr (attrsOf (either path str));
        description = ''
          An Attributeset of hooks which get copied to <literal>~/.gitolite/hooks/repo-specific</literal>.
        '';
        default = null;
      };

      user = mkOption {
        type = types.str;
        default = "gitolite";
        description = ''
          Gitolite user account. This is the username of the gitolite endpoint.
        '';
      };

      mutable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enables configuration of gitolite through nix.
          This disables the gitolite-admin repo and enables repos, keys, rc and customFiles.
        '';
      };

      customFiles = mkOption {
        type = types.nullOr (types.listOf (types.submodule {
          options = {
            path = mkOption {
              type = types.str;
              description = ''
                Location of the custom defined file.
              '';
            };
            file = mkOption {
              type = with types; either path str;
              description = ''
                string or path of the content of the customFile.
              '';
            };
          };
        }));
        description = ''
          custom files to lay into the configured dataDir. Will override any files which are specified here.
          Use with care!
        '';
        example = [
            {
              name = ".gitolite/conf/irc-announce.conf";
              content = ''
                #!/bin/sh
                contents of some file
                ...
              '';
            }
          ];
        default = null;
      };

      keys = mkOption {
        type = with types; attrsOf (either path str);
        description = ''
          Ssh-keys which get copied into keydir.
        '';
        example = {
          user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM1v/N0G7k48thX1vIALTdqrdYUvYM+SvHRq/rCcKLC2 user@host";
        };
        default = {};
      };

      rc = mkOption {
        type = with types; nullOr (either path str);
        description = ''
          String or path to specify the used .gitolite.rc in your gitolite dataDir. If unspecified the original one is left untouched.
        '';
        default = null;
      };

      repos = mkOption {
        type = with types; nullOr (attrsOf (submodule {
          options = {
            extraConfig = mkOption {
              type = nullOr str;
              default = null;
              description = ''
                Additional lines of text which get appended to the repos config in gitolite.conf.
              '';
            };

            users = mkOption {
              type = attrsOf str;
              description = ''
                users to configure this gitolite repo for, with usernames as attributeNames and permissions (as strings) as attributes.
              '';
            };
          };
        }));
        description = ''
          Repos to be defined.
        '';
        example = {
          config = {
            users = {
              tv = "R";
              lass = "RW+";
            };
            extraConfig = ''
              option hook.post-receive = irc-announce
            '';
          };
        };
        default = null;
      };
    };
  };


  config = mkIf cfg.enable {

    users.extraUsers.${cfg.user} = {
      description     = "Gitolite user";
      home            = cfg.dataDir;
      createHome      = true;
      uid             = config.ids.uids.gitolite;
      useDefaultShell = true;
    };

    systemd.services."gitolite-init" = {
      description = "Gitolite initialization";
      wantedBy    = [ "multi-user.target" ];

      serviceConfig.User = "${cfg.user}";
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;

      path = [ pkgs.gitolite pkgs.git pkgs.perl pkgs.bash config.programs.ssh.package ];
      script = ''
        cd ${escapeShellArg cfg.dataDir}
        mkdir -p .gitolite/logs

        ${optionalString (cfg.commonHooks != null) ''
          find .gitolite/hooks/common/ -maxdepth 1 -type f -not -name 'update' -delete
          ${(concatStringsSep "\n" (map writeCommonHooks (attrNames cfg.commonHooks)))}
        ''}

        ${optionalString (cfg.repoSpecificHooks != null) ''
          mkdir -p .gitolite/hooks/repo-specific
          find .gitolite/hooks/repo-specific/ -maxdepth 1 -type f -delete
          ${(concatStringsSep "\n" (map copyRepoSpecificHooks (attrNames cfg.repoSpecificHooks)))}
        ''}

        ${if cfg.mutable then
          optionalString (cfg.adminPubkey != null) ''
            if [ ! -d repositories ]; then
              gitolite setup -pk ${adminPubkey}
            fi
          ''
        else
          concatStrings [
            (optionalString (cfg.keys != {}) ''
              mkdir -p .gitolite/{keydir,conf}
              mkdir -p .gitolite/hooks/{common,repo-specific}
              rm -f .gitolite/keydir/*
              ${concatStringsSep "\n" (map writeKey (attrNames cfg.keys))}
            '')
            (optionalString (isAttrs cfg.repos) createGitoliteConfig)
            (optionalString (cfg.rc != null) writeGitoliteRc)
            (optionalString (cfg.customFiles != null) (concatStringsSep "\n" (map writeCustomFile cfg.customFiles)))
          ]
        }

        gitolite setup # Upgrade if needed
      '';
    };

    environment.systemPackages = [ pkgs.gitolite pkgs.git ];
  };
}
