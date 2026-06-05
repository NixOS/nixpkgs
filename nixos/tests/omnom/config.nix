{ config, pkgs, ... }:
{
  services.omnom = {
    enable = true;
    openFirewall = true;

    port = 9090;

    settings = {
      app = {
        disable_signup = false; # restrict CLI user-creation
        results_per_page = 50;
      };
      server.address = "0.0.0.0:${toString config.services.omnom.port}";
    };
  };

  programs.firefox = {
    enable = true;
    # librewolf allows installations of unsigned extensions
    package = pkgs.wrapFirefox pkgs.librewolf-unwrapped {
      nixExtensions = [
        (
          let
            # specified in manifest.json of the addon
            extid = "{f0bca7ce-0cda-41dc-9ea8-126a50fed280}";
          in
          pkgs.runCommand "omnom" { passthru = { inherit extid; }; } ''
            mkdir -p $out
            cp ${pkgs.omnom}/share/addons/omnom_ext_firefox.zip $out/${extid}.xpi
          ''
        )
      ];
    };
  };
}
