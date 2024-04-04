{ stdenvNoCC
, lib
, fetchFromGitHub
, makeWrapper
, bash
, jq
, killall
, libnotify
, curl
, busybox
}:

stdenvNoCC.mkDerivation {
  pname = "nist-feed";
  version = "0-unstable-2024-01-20";

  src = fetchFromGitHub {
    owner = "D3vil0p3r";
    repo = "NIST-Feed";
    rev = "775bd871490b680784a1855cdc1d4958a83a7866";
    hash = "sha256-OcVf766q7vELYkGOEzQMLS6zH8Nn96ibGP+6kizHN28=";
  };

  patches = [
    ./cron.patch
  ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace nist-feed \
      --replace "/usr/local/bin/nist-feed" $out/bin/nist-feed
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 nist-feed $out/bin/nist-feed
    wrapProgram "$out/bin/nist-feed" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ jq killall libnotify curl busybox ]}"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Notification daemon for CVEs from the NIST National Vulnerability Database";
    homepage = "https://github.com/D3vil0p3r/NIST-Feed/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ octodi ];
    mainProgram = "nist-feed";
  };
}
