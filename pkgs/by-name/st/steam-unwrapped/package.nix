{
  lib,
  stdenv,
  fetchurl,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "steam-unwrapped";
  version = "1.0.0.85";

  src = fetchurl {
    # use archive url so the tarball doesn't 404 on a new release
    url = "https://repo.steampowered.com/steam/archive/stable/steam_${finalAttrs.version}.tar.gz";
    hash = "sha256-fy03Si+0E87VuBJRUUViGdkYolWHK0u3cBbLzPOLt/E=";
  };

  patches = [
    # We copy the bootstrap file from the store, where it's read-only,
    # so future attempts to update it with bare "cp" will fail.
    # So, use "cp -f" to force an overwrite.
    ./force-overwrite-bootstrap.patch
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    rm $out/bin/steamdeps

    # install udev rules
    mkdir -p $out/etc/udev/rules.d/
    cp ./subprojects/steam-devices/*.rules $out/etc/udev/rules.d/
    substituteInPlace $out/etc/udev/rules.d/60-steam-input.rules \
      --replace-fail "/bin/sh" "${bash}/bin/bash"

    # this just installs a link, "steam.desktop -> /lib/steam/steam.desktop"
    rm $out/share/applications/steam.desktop
    substitute steam.desktop $out/share/applications/steam.desktop \
      --replace-fail /usr/bin/steam steam
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Digital distribution platform";
    longDescription = ''
      Steam is a video game digital distribution service and storefront from Valve.

      To install on NixOS, please use the option `programs.steam.enable = true`.
    '';
    homepage = "https://store.steampowered.com/";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ jagajaga ];
    teams = with lib.teams; [ steam ];
    mainProgram = "steam";
  };
})
