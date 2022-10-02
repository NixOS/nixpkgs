{ lib, stdenv, python3}:

let

  default = {
    python3 = let
      env = (python3.withPackages (ps: with ps; [ ipykernel ]));
    in {
      displayName = "Python 3";
      argv = [
        env.interpreter
        "-m"
        "ipykernel_launcher"
        "-f"
        "{connection_file}"
      ];
      language = "python";
      logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
      logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
    };
  };

in
{
  inherit default;

  # Definitions is an attribute set.

  create = { definitions ?  default }: with lib; stdenv.mkDerivation {

    name = "jupyter-kernels";

    src = "/dev/null";

    unpackCmd = "mkdir jupyter_kernels";

    installPhase =  ''
      mkdir kernels

      ${concatStringsSep "\n" (mapAttrsToList (kernelName: unfilteredKernel:
        let
          allowedKernelKeys = ["argv" "displayName" "language" "interruptMode" "env" "metadata" "logo32" "logo64" "extraPaths"];
          kernel = filterAttrs (n: v: (any (x: x == n) allowedKernelKeys)) unfilteredKernel;
          config = builtins.toJSON (
            kernel
            // {display_name = if (kernel.displayName != "") then kernel.displayName else kernelName;}
            // (optionalAttrs (kernel ? interruptMode) { interrupt_mode = kernel.interruptMode; })
          );
          extraPaths = kernel.extraPaths or {}
            // lib.optionalAttrs (kernel.logo32 != null) { "logo-32x32.png" = kernel.logo32; }
            // lib.optionalAttrs (kernel.logo64 != null) { "logo-64x64.png" = kernel.logo64; }
          ;
          linkExtraPaths = lib.mapAttrsToList (name: value: "ln -s ${value} 'kernels/${kernelName}/${name}';") extraPaths;
        in ''
          mkdir 'kernels/${kernelName}';
          echo '${config}' > 'kernels/${kernelName}/kernel.json';
          ${lib.concatStringsSep "\n" linkExtraPaths}
        '') definitions)}

      mkdir $out
      cp -r kernels $out
    '';

    meta = {
      description = "Wrapper to create jupyter notebook kernel definitions";
      homepage = "https://jupyter.org/";
      maintainers = with maintainers; [ aborsu ];
    };
  };
}
