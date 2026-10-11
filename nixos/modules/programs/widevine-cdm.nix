{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.widevine-cdm;

  # `chromium` and `ungoogled-chromium` are patched via their native
  # `enableWideVine` flag. Every other fork is patched by copying the CDM next
  # to its real executable
  wrapBrowser =
    browser:
    let
      pname = lib.getName browser;
      binaryName = browser.meta.mainProgram or pname;
    in
    if pname == "chromium" || pname == "ungoogled-chromium" then
      browser.override { enableWideVine = true; }
    else
      browser.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          exe=$(find "$out" -type f -name '${lib.escapeShellArg binaryName}' -executable -not -path '*/bin/*' | head -n1)
          if [ -n "$exe" ]; then
            dir=$(dirname "$exe")
          else
            dir="$out"
          fi
          mkdir -p "$dir"
          cp -a "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm" "$dir/WidevineCdm"
        '';
      });
in
{
  options.programs.widevine-cdm = {
    enable = lib.mkEnableOption "Widevine CDM support in Chromium-family browsers";

    browsers = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression ''
        [
          pkgs.chromium
          pkgs.ungoogled-chromium
        ]
      '';
      description = ''
        Chromium-family browsers to patch with the Widevine CDM.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = map wrapBrowser cfg.browsers;
  };
}
