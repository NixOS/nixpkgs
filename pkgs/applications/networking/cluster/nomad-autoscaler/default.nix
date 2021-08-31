{ lib, fetchFromGitHub, buildGoModule, go, removeReferencesTo, buildEnv }:

let
  package = buildGoModule rec {
    pname = "nomad-autoscaler";
    version = "0.3.3";

    outputs = [
      "out"
      "bin"
      "aws_asg"
      "azure_vmss"
      "datadog"
      "fixed_value"
      "gce_mig"
      "nomad_apm"
      "nomad_target"
      "pass_through"
      "prometheus"
      "target_value"
      "threshold"
    ];

    src = fetchFromGitHub {
      owner = "hashicorp";
      repo = "nomad-autoscaler";
      rev = "v${version}";
      sha256 = "sha256-bN/U6aCf33B88ouQwTGG8CqARzWmIvXNr5JPr3l8cVI=";
    };

    vendorSha256 = "sha256-Ls8gkfLyxfQD8krvxjAPnZhf1r1s2MhtQfMMfp8hJII=";

    subPackages = [ "." ];

    nativeBuildInputs = [ removeReferencesTo ];

    # buildGoModule overrides normal buildPhase, can't use makeTargets
    postBuild = ''
      make build plugins
    '';

    # tries to pull tests from network, and fails silently anyway
    doCheck = false;

    postInstall = ''
      mkdir -p $bin/bin
      mv $out/bin/nomad-autoscaler $bin/bin/nomad-autoscaler
      ln -s $bin/bin/nomad-autoscaler $out/bin/nomad-autoscaler

      for d in $outputs; do
        mkdir -p ''${!d}/share
      done
      rmdir $bin/share

      # have out contain all of the plugins
      for plugin in bin/plugins/*; do
        remove-references-to -t ${go} "$plugin"
        cp "$plugin" $out/share/
      done

      # populate the outputs as individual plugins
      # can't think of a more generic way to handle this
      # bash doesn't allow for dashes '-' to be in a variable name
      # this means that the output names will need to differ slightly from the binary
      mv bin/plugins/aws-asg $aws_asg/share/
      mv bin/plugins/azure-vmss $azure_vmss/share/
      mv bin/plugins/datadog $datadog/share/
      mv bin/plugins/fixed-value $fixed_value/share/
      mv bin/plugins/gce-mig $gce_mig/share/
      mv bin/plugins/nomad-apm $nomad_apm/share/
      mv bin/plugins/nomad-target $nomad_target/share/
      mv bin/plugins/pass-through $pass_through/share/
      mv bin/plugins/prometheus $prometheus/share/
      mv bin/plugins/target-value $target_value/share/
      mv bin/plugins/threshold $threshold/share/
    '';

    # make toggle-able, so that overrided versions can disable this check if
    # they want newer versions of the plugins without having to modify
    # the output logic
    doInstallCheck = true;
    installCheckPhase = ''
      rmdir bin/plugins || {
        echo "Not all plugins were extracted"
        echo "Please move the following to their related output: $(ls bin/plugins)"
        exit 1
      }
    '';

    passthru = {
      inherit plugins withPlugins;
    };

    meta = with lib; {
      description = "Autoscaling daemon for Nomad";
      homepage = "https://github.com/hashicorp/nomad-autoscaler";
      license = licenses.mpl20;
      maintainers = with maintainers; [ jonringer ];
    };
  };

  plugins = let
      plugins = builtins.filter (n: !(lib.elem n [ "out" "bin" ])) package.outputs;
    in lib.genAttrs plugins (output: package.${output});

  # Intended to be used as: (nomad-autoscaler.withPlugins (ps: [ ps.aws_asg ps.nomad_target ])
  withPlugins = f: buildEnv {
    name = "nomad-autoscaler-env";
    paths = [ package.bin ] ++ f plugins;
  };
in
  package
