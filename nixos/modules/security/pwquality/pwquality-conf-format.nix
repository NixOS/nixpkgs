{ pkgs, lib, ... }:

let
  inherit (lib) types;
  inherit (pkgs) testers;
in

rec {
  type = types.submodule {
    freeformType =
      with types;
      (attrsOf (
        nullOr (oneOf [
          str
          int
          bool
          (listOf str)
        ])
      ))
      // {
        description = "settings option";
      };

    options = {
      difok = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 1;
        description = ''
          Number of characters in the new password that must not be present in
          the old password.

          The special value of `0` disables all checks of similarity of the new
          password with the old password except the new password being exactly
          the same as the old one.
        '';
      };

      minlen = lib.mkOption {
        type = types.nullOr (
          types.addCheck types.int (x: x >= 6)
          // {
            name = "positiveIntMinSix";
            description = "positive integer >= 6";
          }
        );
        default = null;
        example = 8;
        description = ''
          The minimum acceptable size for the new password. In addition to the
          number of characters in the new password, credit (up to the individual
          credit setting in length) is given for each different kind of
          character (other, upper, lower and digit). Set the individual credit
          settings to `0` or negative to have `minlen` count as true length of
          the new password in characters.

          Note that there is a pair of length limits also in Cracklib, which is
          used for dictionary checking, a "way too short" limit of `4` which is
          hard coded in and a build time defined limit (`6`) that will be checked
          without reference to `minlen`.

          Cannot be set to lower value than `6`.

        '';
      };

      dcredit = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 0;
        description = ''
          The maximum credit for having digits in the new password. If less than
          `0` it is the minimum number of digits in the new password.
        '';
      };

      ucredit = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 0;
        description = ''
          The maximum credit for having uppercase characters in the new
          password. If less than `0` it is the minimum number of uppercase
          characters in the new password.
        '';
      };

      lcredit = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 0;
        description = ''
          The maximum credit for having lowercase characters in the new
          password. If less than `0` it is the minimum number of lowercase
          characters in the new password.
        '';
      };

      ocredit = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 0;
        description = ''
          The maximum credit for having other characters in the new password. If
          less than `0` it is the minimum number of other characters in the new
          password.
        '';
      };

      minclass = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 0;
        description = ''
          The minimum number of required classes of characters for the new
          password (digits, uppercase, lowercase, others).
        '';
      };

      maxrepeat = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 0;
        description = ''
          The maximum number of allowed same consecutive characters in the new
          password.

          The check is disabled if the value is `0`.
        '';
      };

      maxsequence = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 0;
        description = ''
          The maximum length of monotonic character sequences in the new
          password. Examples of such sequence are '12345' or 'fedcb'. Note that
          most such passwords will not pass the simplicity check unless the
          sequence is only a minor part of the password.

          The check is disabled if the value is `0`.
        '';
      };

      maxclassrepeat = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 0;
        description = ''
          The maximum number of allowed consecutive characters of the same class
          in the new password.

          The check is disabled if the value is `0`.
        '';
      };

      gecoscheck = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 0;
        description = ''
          If nonzero, check whether the words longer than `3` characters from
          the *GECOS* field of the user's {manpage}`passwd(5)` entry are
          contained in the new password.

          The check is disabled if the value is `0`.
        '';
      };

      dictcheck = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 1;
        description = ''
          If nonzero, check whether the password (with possible modifications)
          matches a word in a dictionary.

          Currently the dictionary check is performed using the `cracklib`
          library.
        '';
      };

      usercheck = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 1;
        description = ''
          If nonzero, check whether the password (with possible modifications)
          contains the user name in some form.

          It is not performed for user names shorter than `3` characters.
        '';
      };

      usersubstr = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 0;
        description = ''
          If greater than `3` (due to the minimum length in `usercheck`), check
          whether the password contains a substring of at least *N* length in
          some form.
        '';
      };

      # as the description suggests internally it's only used for pam, but
      # other tooling could rely upon it so best to keep in all pwquality config
      enforcing = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 1;
        description = ''
          If nonzero, reject the password if it fails the checks, otherwise only
          print the warning.

          This setting applies only to the `pam_pwquality` module and possibly
          other applications that explicitly change their behavior based on it.
          It does not affect {manpage}`pwmake(1)` and {manpage}`pwscore(1)`.
        '';
      };

      badwords = lib.mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        example = [
          "password"
          "pass"
          "hunter42"
        ];
        # adjust the description from "space separated" to reflect an actual
        # list within nix
        description = ''
          A list of words that must not be contained in the password. These are
          additional words to the `cracklib` dictionary check. This setting can
          be also used by applications to emulate the `gecos` check for user
          accounts that are not created yet.
        '';
      };

      dictpath = lib.mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/usr/local/lib/pw_dict";
        description = ''
          Path to the `cracklib` dictionaries.
          Default is to use the `cracklib` default.
        '';
      };

      retry = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 1;
        description = ''
          Prompt user at most *N* times before returning with error.
        '';
      };

      enforce_for_root = lib.mkOption {
        type = types.nullOr types.bool;
        default = null;
        example = false;
        description = ''
          The module will return error on failed check even if the user
          changing the password is `root`.

          This option is off by default which means that just the message about
          the failed check is printed but `root` can change the password anyway.
          Note that `root` is not asked for an old password so the checks that
          compare the old and new password are not performed.
        '';
      };

      local_users_only = lib.mkOption {
        type = types.nullOr types.bool;
        default = null;
        example = false;
        description = ''
          The module will not test the password quality for users that are not
          present in the {file}`/etc/passwd` file. The module still asks for the
          password so the following modules in the stack can use the
          `use_authtok` ({manpage}`pam_unix(8)`) option.
        '';
      };
    };
  };

  # filter out "unset" null cases and false which isn't a part of the format
  baseFilter = settings: (lib.filterAttrs (_: v: v != null && v != false) settings);

  generate =
    name: settings:
    # concatMapStrings rather than concatStringsSep to ensure last line also
    # gets trailing newline for EOF
    pkgs.writeText name (
      lib.concatMapStrings (x: x + "\n") (
        lib.mapAttrsToList (
          name: value:
          if value == true then
            # just include name
            name
          else
            # assert to be safe that false has been filtered
            assert value != false;
            # key value, toString handles lists in the correct way as simply
            # space separated
            "${name} = ${toString value}"
        ) (baseFilter settings)
      )
    );

  # explicitly convert internal lists to space separated strings matching
  # internal pam config expectations in `moduleSettingsType` at the top of
  # `nixos/modules/security/pam.nix`
  pamApply = d: lib.mapAttrs (_: v: if lib.isList v then toString v else v) (baseFilter d);

  # tests adopted into libpwquality.passthru.tests.format
  tests = {
    generate-basic = testers.testEqualContents {
      assertion = "basic settings match";
      # attr -> list -> string
      # attrs don't maintain order and are sorted alphabetically
      expected = pkgs.writeText "expected" ''
        badwords = foobar hunter42 password
        enforce_for_root
        minclass = 4
        minlen = 10
      '';
      # matches settings in nixos test, keep in sync
      actual = generate "actual" {
        # numbers
        minlen = 10;
        minclass = 4;

        # list of str
        badwords = [
          "foobar"
          "hunter42"
          "password"
        ];

        # bool
        enforce_for_root = true;
      };
    };

    generate-falsy = testers.testEqualContents {
      assertion = "false should not appear";
      expected = pkgs.writeText "expected" ''
        difok = 0
        local_users_only
        ocredit = -1
      '';
      actual = generate "actual" {
        # include
        local_users_only = true;
        # drop
        enforce_for_root = false;
        dictpath = null;
        # potentially difficult numbers
        ocredit = -1;
        difok = 0;
      };
    };

    pamApply-list-becomes-string = testers.testEqualContents {
      assertion = "known list is converted to a space separated string for pam";
      expected = pkgs.writeText "expected" "foobar hunter42 password";
      actual =
        pkgs.writeText "actual"
          (pamApply {
            badwords = [
              "foobar"
              "hunter42"
              "password"
            ];
          }).badwords;
    };
  };
}
