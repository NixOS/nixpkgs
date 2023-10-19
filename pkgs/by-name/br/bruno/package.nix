{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, wrapGAppsHook
, alsa-lib
, gtk3
, mesa
, nspr
, nss
, systemd
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "bruno";
  version = "0.17.0";

  src = fetchurl {
    url = "https://github.com/usebruno/bruno/releases/download/v${version}/bruno_${version}_amd64_linux.deb";
    hash = "sha256-4FF9SEgWuIPQSarOBTaEvgdgRTkR1caRYr/bjfFmTLE=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg wrapGAppsHook ];

  buildInputs = [
    alsa-lib
    gtk3
    mesa
    nspr
    nss
  ];

  runtimeDependencies = [ (lib.getLib systemd) ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp -R opt $out
    cp -R "usr/share" "$out/share"
    ln -s "$out/opt/Bruno/bruno" "$out/bin/bruno"
    chmod -R g-w "$out"
    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace "$out/share/applications/bruno.desktop" \
      --replace "/opt/Bruno/bruno" "$out/bin/bruno"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Open-source IDE For exploring and testing APIs.";
    homepage = "https://www.usebruno.com";
    license = licenses.mit;
    maintainers = with maintainers; [ water-sucks lucasew ];
    platforms = [ "x86_64-linux" ];
  };
}
