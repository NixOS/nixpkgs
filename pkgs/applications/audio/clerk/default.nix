{
  lib,
  fetchFromGitHub,
  fzf,
  installShellFiles,
  libnotify,
  makeWrapper,
  mpc,
  perlPackages,
  rofi,
  stdenv,
  tmux,
  unstableGitUpdater,
  util-linux,
}:

stdenv.mkDerivation {
  pname = "clerk";
  version = "4.0.5-unstable-2023-10-07";

  src = fetchFromGitHub {
    owner = "carnager";
    repo = "clerk";
    rev = "907138d8fc2b1709fb49d062d0b663a48eb210bd";
    hash = "sha256-V2nDLq2ViC5Twve0EILBEYOdEavqgYB/TQq/T+ftfmk=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

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

  postPatch = ''
    substituteInPlace clerk_rating_client.service \
      --replace "/usr" "$out"
  '';

  installPhase = ''
    runHook preInstall

    mv clerk.pl clerk
    installBin clerk clerk_rating_client
    install -D clerk_rating_client.service $out/lib/systemd/user/clerk_rating_client.service

    runHook postInstall
  '';

  postFixup =
    let
      binPath = lib.makeBinPath [
        fzf
        libnotify
        mpc
        rofi
        tmux
        util-linux
      ];
    in
    ''
      pushd $out/bin
      for f in clerk clerk_rating_client; do
        wrapProgram $f \
          --prefix PATH : "${binPath}" \
          --set PERL5LIB $PERL5LIB
      done
      popd
    '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/carnager/clerk.git";
    hardcodeZeroVersion = true;
  };

  meta = {
    homepage = "https://github.com/carnager/clerk";
    description = "MPD client based on rofi/fzf";
    license = lib.licenses.mit;
    mainProgram = "clerk";
    maintainers = with lib.maintainers; [
      anderspapitto
      rewine
      AndersonTorres
    ];
    platforms = lib.platforms.linux;
  };
}
