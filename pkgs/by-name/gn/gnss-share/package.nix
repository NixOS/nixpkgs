{
  buildGoModule,
  fetchFromGitLab,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "gnss-share";
  version = "0.8.1";
  src = fetchFromGitLab {
    owner = "postmarketOS";
    repo = "gnss-share";
    rev = finalAttrs.version;
    hash = "sha256-4X1oiQWn2oZPw/14hNyZ0a6FEwoykotBisY6lk6lj2k=";
  };
  vendorHash = "sha256-dmE6hfKUqEr7BMNi/HMUOk4jDB0dPXEMkWQyWj6XpY4=";
  meta = {
    description = "Share GNSS data between multiple clients";
    longDescription = ''
      gnss-share is an app that facilitates sharing GNSS location data with multiple
      clients, while providing a way to perform device-specific setup beforehand. For
      some devices, it can also manage loading and storing A-GPS data.

      This is meant to replace things like gpsd, and gps-share, and work together
      with geoclue* or other clients that support fetching NMEA location data over
      sockets.
    '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ balsoft ];
    mainProgram = "gnss-share";
  };
})
