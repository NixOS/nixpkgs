{ lib }:
{
  tlsRecommendationsOption = lib.mkOption {
    type = lib.types.nullOr (
      lib.types.enum [
        "modern"
        "intermediate"
        "old"
      ]
    );
    default = null;
    example = "intermediate";
    description = ''
      TLS settings recommendations from Mozilla’s ssl-config-generator project
      (see <https://ssl-config.mozilla.org>).

      modern
      : Services with clients that support TLS 1.3 and don’t need backward compatibility

      intermediate
      : General-purpose servers with a variety of clients, recommended for almost all systems

      old
      : Compatible with a number of very old clients, and should be used only as a last resort
    '';
  };
}
