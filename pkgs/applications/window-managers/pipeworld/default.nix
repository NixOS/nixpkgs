{ stdenv
, lib
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, runtimeShell
, bash
, arcan
, makeWrapper
, withXarcan ? true
, xarcan
}:

stdenv.mkDerivation rec {
  pname = "pipeworld";
  version = "0.0.0+unstable=2021-05-27";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = pname;
    rev = "c26df9ca0225ce2fd4f89e7ec59d4ab1f94a4c2e";
    sha256 = "sha256-RkDAbM1q4o61RGPLPLXHLvbvClp+bfjodlWgUGoODzA=";
  };

  buildInputs = [
    arcan
    makeWrapper
  ] ++ lib.optionals withXarcan [
    xarcan
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Pipeworld";
    exec = pname;
    comment = "Zooming-Tiling window manager for Arcan";
    type = "Application";
    terminal = "false";
  };

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin $out/share/${pname}

    # Copy appl's source
    cp --recursive ./pipeworld/* $out/share/${pname}/

    # Add command
    echo "#!${runtimeShell}

    exec arcan $out/share/${pname}" > $out/bin/${pname}
    chmod +x $out/bin/${pname}

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/${pname} --prefix PATH : ${lib.makeBinPath [ arcan ]}
  '';

  meta = with lib; {
    description = "A dataflow programming and desktop environment";
    homepage = "https://github.com/letoram/pipeworld";
    changelog = "https://github.com/letoram/pipeworld/releases/tag/${version}";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ a12l ];
  };
}
