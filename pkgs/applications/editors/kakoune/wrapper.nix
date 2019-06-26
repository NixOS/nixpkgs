{ stdenv, bash }:
with stdenv.lib;

kakoune:

let
  getPlugins = { plugins ? [] }: plugins;

  wrapper = { configure ? {} }:
  stdenv.mkDerivation rec {
    pname = "kakoune";
    version = getVersion kakoune;

    src = ./.;
    buildCommand = ''
      mkdir -p $out/share/kak
      for plugin in ${strings.escapeShellArgs (getPlugins configure)}; do
        if [[ -d $plugin/share/kak/autoload ]]; then
          find "$plugin/share/kak/autoload" -type f -name '*.kak'| while read rcfile; do
            printf 'source "%s"\n' "$rcfile"
          done
        fi
      done >>$out/share/kak/plugins.kak

      mkdir -p $out/bin
      substitute ${src}/wrapper.sh $out/bin/kak \
        --subst-var-by bash "${bash}" \
        --subst-var-by kakoune "${kakoune}" \
        --subst-var-by out "$out"
      chmod +x $out/bin/kak
    '';

    preferLocalBuild = true;
    buildInputs = [ bash kakoune ];
    passthru = { unwrapped = kakoune; };

    meta = kakoune.meta // {
      # prefer wrapper over the package
      priority = (kakoune.meta.priority or 0) - 1;
      hydraPlatforms = [];
    };
  };
in
  makeOverridable wrapper
