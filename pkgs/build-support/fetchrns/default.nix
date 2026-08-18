{
  lib,
  fetchgit,
  python3Packages,
  formats,
  writableTmpDirAsHomeHook,
}:
lib.makeOverridable (
  {
    rnsdConfig ? {
      reticulum = {
        enable_transport = true;
      };
      interfaces = {
        "local" = {
          type = "TCPClientInterface";
          enabled = true;
          target_host = "127.0.0.1";
          target_port = "4242";
        };
      };
    },
    execRnpath ? false,
    ...
  }@args:
  fetchgit (
    {
      preFetch =
        let
          settingsFormat = formats.configobj { };

          buildConfig = ''
            install -D -m 600 ${settingsFormat.generate "rnsd-config" rnsdConfig} $PWD/.config/reticulum/config
          '';

          exportConfig = ''
            RNS_CONFIG=$PWD/.config/reticulum
            export RNS_CONFIG
          '';

          runRnpath = ''
            hash="''${url#rns://}"
            hash="''${hash%%/*}"

            rnpath --config $PWD/.config/reticulum "$hash" --verbose
          '';
        in
        buildConfig + exportConfig + (lib.optionalString execRnpath runRnpath);

      nativeBuildInputs =
        with python3Packages;
        [
          rns
        ]
        ++ lib.optionals execRnpath [
          writableTmpDirAsHomeHook
        ];
    }
    // removeAttrs args [
      "rnsdConfig"
      "execRnpath"
    ]
  )
)
