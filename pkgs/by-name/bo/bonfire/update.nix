{
  coreutils,
  lib,
  nix,
  nurl,
  writeShellApplication,
  callPackage,
  beamPkgs,
  bonfireAttrs,
}:
{
  script = writeShellApplication {
    name = "bonfire-${bonfireAttrs.env.FLAVOUR}-update";
    runtimeInputs = [
      bonfireAttrs.passthru.yarn-berry.yarn-berry-fetcher
      coreutils
      nix
      nurl
    ];
    text = lib.concatStringsSep "\n" [
      "set -x"

      # ToDo(maint/update): use gitUpdater instead of nurl
      # whenever all extensions have a release tag.
      #
      # Explanation: updating the extensions
      # must come before updating the dependencies in `deps.nix`,
      # which uses the extensions.
      (lib.concatMapStringsSep "\n" (ext: ''
        mkdir -p pkgs/by-name/bo/bonfire/extensions/${ext.name}
        {
          echo "{ fetchFromGitHub, ... }:"
          nurl https://github.com/bonfire-networks/${ext.name}
          echo
        } >pkgs/by-name/bo/bonfire/extensions/${ext.name}/fetchFromGitHub.nix
      '') bonfireAttrs.passthru.flavour-extensions)

      # Description: update pkgs/by-name/bo/bonfire-${bonfireAttrs.env.FLAVOUR}/deps.nix
      # using deps_nix.
      # bash
      ''
        deps=$(
            nix -L --show-trace --extra-experimental-features "nix-command" \
                build \
                --option sandbox relaxed \
                --no-link --print-out-paths \
                -f . \
                bonfire-${bonfireAttrs.env.FLAVOUR}.passthru.update.package
        )
        mkdir -p pkgs/by-name/bo/bonfire/extensions/${bonfireAttrs.env.FLAVOUR}/
        cp -f "$deps" pkgs/by-name/bo/bonfire/extensions/${bonfireAttrs.env.FLAVOUR}/deps.nix
      ''

      # Description: update Rust and Yarn dependencies depending on `deps.nix` for `Fbonfire.LAVOUR`,
      # but not for the extensions that `bonfireAttrs.env.FLAVOUR` depends on.
      # This must currently be done when considering those extensions as a flavour themselves.
      ''
        nix --extra-experimental-features "nix-command" -L run \
          --option sandbox relaxed \
          -f . bonfire-${bonfireAttrs.env.FLAVOUR}.update.after-mixNixDeps
      ''
    ];
  };

  package = callPackage ./mix-update.nix {
    inherit beamPkgs;
    packageAttrs = bonfireAttrs // {
      postPatch =
        bonfireAttrs.postPatch or ""
        + lib.concatStringsSep "\n" [
          # Explanation: re-enable downloading of locales.
          ''
            cat >>config/config.exs <<EOF

            config :bonfire_common, Bonfire.Common.Localise.Cldr,
              force_locale_download: false
            EOF
          ''
          # Explanation: re-enable downloading of precompiled Rust libs.
          ''
            cat >>config/config.exs <<EOF

            config :decent,
                    Decent.Native,
                    skip_compilation?: true
            config :lumis,
                    Lumis.Native,
                    skip_compilation?: true
            config :mdex_native,
                    MDEx.Native,
                    skip_compilation?: true
            config :mjml,
                    Mjml.Native,
                    skip_compilation?: true
            config :tokenizers,
                    Tokenizers.Native,
                    skip_compilation?: true,
            EOF
          ''
        ];
    };
    # Explanation: deps_nix needs to be injected into bonfire's mix.exs
    deps_nix_injection_pattern = "extra_deps =";
  };
}
