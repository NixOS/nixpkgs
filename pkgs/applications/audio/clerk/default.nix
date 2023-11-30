{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rofi
, tmux
, fzf
, mpc-cli
, perl
, util-linux
, libnotify
, perlPackages
}:

stdenv.mkDerivation {
  pname = "clerk";
  version = "unstable-2023-10-07";

  src = fetchFromGitHub {
    owner = "carnager";
    repo = "clerk";
    rev = "907138d8fc2b1709fb49d062d0b663a48eb210bd";
    hash = "sha256-V2nDLq2ViC5Twve0EILBEYOdEavqgYB/TQq/T+ftfmk=";
  };

  postPatch = ''
    substituteInPlace clerk_rating_client.service \
      --replace "/usr" "$out"
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = with perlPackages; [
    perl
    DataMessagePack
    DataSectionSimple
    ConfigSimple
    TryTiny
    IPCRun
    HTTPDate
    FileSlurper
    ArrayUtils
    NetMPD
  ];

  dontBuild = true;

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -D clerk.pl $out/bin/clerk
    install -D clerk_rating_client $out/bin/clerk_rating_client
    install -D clerk_rating_client.service $out/lib/systemd/user/clerk_rating_client.service
    runHook postInstall
  '';

  postFixup = let
    binPath = lib.makeBinPath [
      libnotify
      mpc-cli
      rofi
      tmux
      fzf
      util-linux
    ];
  in
  ''
    wrapProgram $out/bin/clerk --set PERL5LIB $PERL5LIB --prefix PATH : "${binPath}"
    wrapProgram $out/bin/clerk_rating_client --set PERL5LIB $PERL5LIB --prefix PATH : "${binPath}"
  '';

  meta = with lib; {
    description = "An MPD client based on rofi/fzf";
    homepage = "https://github.com/carnager/clerk";
    license = licenses.mit;
    maintainers = with maintainers; [ anderspapitto rewine ];
    mainProgram = "clerk";
    platforms = platforms.linux;
  };
}
