{
  lib,
  stdenv,
  fetchurl,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "steam-unwrapped";
  version = "1.0.0.81";

  src = fetchurl {
    # use archive url so the tarball doesn't 404 on a new release
    url = "https://repo.steampowered.com/steam/archive/stable/steam_${finalAttrs.version}.tar.gz";
    hash = "sha256-Gia5182s4J4E3Ia1EeC5kjJX9mSltsr+b+1eRtEXtPk=";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  postInstall = ''
    rm $out/bin/steamdeps

    # install udev rules
    mkdir -p $out/etc/udev/rules.d/
    cp ./subprojects/steam-devices/*.rules $out/etc/udev/rules.d/
    substituteInPlace $out/etc/udev/rules.d/60-steam-input.rules \
      --replace "/bin/sh" "${bash}/bin/bash"

    # this just installs a link, "steam.desktop -> /lib/steam/steam.desktop"
    rm $out/share/applications/steam.desktop
    sed -e 's,/usr/bin/steam,steam,g' steam.desktop > $out/share/applications/steam.desktop
  '';

  passthru.updateScript = ./update.py;

  meta = with lib; {
    description = "Digital distribution platform";
    longDescription = ''
      Steam is a video game digital distribution service and storefront from Valve.

      To install on NixOS, please use the option `programs.steam.enable = true`.
    '';
    homepage = "https://store.steampowered.com/";
    license = licenses.unfreeRedistributable;
    maintainers = lib.teams.steam.members ++ [ lib.maintainers.jagajaga ];
    mainProgram = "steam";
  };
})
