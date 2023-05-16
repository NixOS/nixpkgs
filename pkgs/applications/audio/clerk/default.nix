{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rofi
<<<<<<< HEAD
, tmux
, fzf
, mpc-cli
, perl
, util-linux
, libnotify
, perlPackages
=======
, mpc-cli
, perl
, util-linux
, python3Packages
, libnotify
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation {
  pname = "clerk";
<<<<<<< HEAD
  version = "unstable-2023-01-14";
=======
  version = "unstable-2016-10-14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "carnager";
    repo = "clerk";
<<<<<<< HEAD
    rev = "90c0e702fc4f8b65f0ced7b8944c063629e3686d";
    hash = "sha256-nkm1vJaWgN8gOkmAbsjPfstax8TwUSkEzYKJ1iEz1hM";
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
=======
    rev = "875963bcae095ac1db174627183c76ebe165f787";
    sha256 = "0y045my65hr3hjyx13jrnyg6g3wb41phqb1m7azc4l6vx6r4124b";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3Packages.mpd2 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontBuild = true;

  strictDeps = true;

<<<<<<< HEAD
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
=======
  installPhase =
    let
      binPath = lib.makeBinPath [
        libnotify
        mpc-cli
        perl
        rofi
        util-linux
      ];
    in
      ''
        runHook preInstall

        DESTDIR=$out PREFIX=/ make install
        wrapProgram $out/bin/clerk --prefix PATH : "${binPath}"

        runHook postInstall
      '';

  meta = with lib; {
    description = "An MPD client built on top of rofi";
    homepage = "https://github.com/carnager/clerk";
    license = licenses.mit;
    broken = true; # not compatible with current version of rofi
    maintainers = with maintainers; [ anderspapitto ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
