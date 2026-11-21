{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "holesail";
  __structuredAttrs = true;
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "holesail";
    repo = "holesail";
    tag = finalAttrs.version;
    hash = "sha256-xIs49HoPV8j0yDPn29WhgS/mkIAEJLRiNNEmKChq0X4=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-WRgC0IH/1Tuw69HQ7Nyf07lAI6SjOpYkIkux9vj8gLw=";

  npmPackFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;

  meta = {
    description = "Peer-to-peer network tunneling and reverse proxy software";
    longDescription = ''
      Holesail is a truly peer-to-peer network tunneling and reverse proxy software that supports both TCP and UDP protocols.
      Holesail lets you share any locally running application on a specific port with third parties securely and with a single command.
      No static IP or port forwarding required.
    '';
    homepage = "https://holesail.io";
    license = lib.licenses.agpl3Only;
    maintainers = [
      lib.maintainers.graysontinker
      lib.maintainers.jjacke13
    ];
    mainProgram = "holesail";
    platforms = lib.platforms.linux;
  };
})
