{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "holesail";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "holesail";
    repo = "holesail";
    tag = finalAttrs.version;
    hash = "sha256-7YTBwjU0xzoDqlRqfdQZrJRvSXTtT8rpA1zRdLSdFoU=";
  };

  npmDepsHash = "sha256-aos1WOsVsgZG6h0g242/mz5yiN/7V+G8to8IyaKldFI=";

  dontNpmBuild = true;

  meta = {
    description = "Peer-to-peer network tunneling and reverse proxy software";
    longDescription = ''
      Holesail is a truly peer-to-peer network tunneling and reverse proxy software that supports both TCP and UDP protocols.
      Holesail lets you share any locally running application on a specific port with third parties securely and with a single command.
      No static IP or port forwarding required.
    '';
    homepage = "https://holesail.io";
    license = lib.licenses.gpl3Only;
    maintainers = [
      lib.maintainers.jjacke13
    ];
    mainProgram = "holesail";
    platforms = lib.platforms.linux;
  };
})
